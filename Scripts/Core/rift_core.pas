unit RiftCore;

interface

uses SysUtils, Classes, Consumables in 'Core\consumables_import.pas';

type
  TRiftIntegerArray = array of Integer;
  TRiftConsumableArray = array of TConsumable;
  TRiftConfig = record
    FarmRiftLevel: Integer;
    MaxMobHP: Integer;
    GoodRooms: TRiftIntegerArray;
    FarmBadRoomsWhileWaiting: Boolean;
    BuffBook: string;
    MapDirectory: string;
    SupplyList: TRiftConsumableArray;
  end;

procedure RiftRun(const Config: TRiftConfig);
procedure RiftCoreOnAction(Action: TL2Action; P1, P2: Pointer);
procedure RiftCoreOnFree;

implementation
// RiftCore implementation. Main scripts pass TRiftConfig to RiftRun.
// Script-level OnAction/OnFree wrappers forward to RiftCore callbacks.
// Inventory and multisell responses are not intercepted.
// Rift reference data transcribed from rift.txt, rift_70_rb.txt, rift_60.txt and rift_60_rb.txt.
// This include contains no Engine calls and does not classify unknown places as RB.
// Policy: 0 = not configured, 1 = farm, 2 = skip.
const
  RIFT_ENTRY_ITEM_ID = 7079;

type
  TRiftPoint = record
    X, Y, Z: Integer;
  end;
  TRiftRoom = record
    Teleport, Guardian: TRiftPoint;
    Corners: array[0..3] of TRiftPoint;
    NpcID: Cardinal;
    MapName: string;
    Policy: Integer;
    HasCoordinates: Boolean; // Recorded teleport and guardian points are available.
    HasBounds: Boolean; // All four room corners are available for polygon detection.
  end;
  TRiftRoute = record
    Count: Integer;
    Points: array[0..7] of TRiftPoint;
  end;

var
  RiftLevel: Integer;
  RiftEntryItemCount: Integer; // Per character, per entry; set by the rift dataset.
  RiftEntryNpcID, RiftBossNpcID: Cardinal;
  RiftRooms: array[1..9] of TRiftRoom; // 1..8 normal rooms; 9 is internal RB slot
  RiftRoutes: array[0..3] of TRiftRoute;
  RiftLobbyTeleport, RiftEntry: TRiftPoint;
  RiftExits: array[0..1] of TRiftPoint;

procedure RiftSetPoint(var P: TRiftPoint; X, Y, Z: Integer);
begin
  P.X := X;
  P.Y := Y;
  P.Z := Z;
end;

procedure RiftLoad60;
var I, J: Integer;
begin
  RiftLevel := 60;
  RiftEntryItemCount := 33; // Per character; configured by the user for rift 60.
  RiftEntryNpcID := 31491;
  RiftBossNpcID := 31900;
  RiftSetPoint(RiftLobbyTeleport, -114796, -179334, -6752);
  RiftSetPoint(RiftEntry, -115335, -178691, -6781);
  RiftSetPoint(RiftExits[0], -114709, -180782, -6752);
  // Only one exit point was recorded; reuse it in the second fixed slot.
  RiftSetPoint(RiftExits[1], -114709, -180782, -6752);

  // Corrected RB teleport/guardian points; corners have not been recorded yet.
  RiftRooms[9].NpcID := RiftBossNpcID;
  RiftRooms[9].Policy := 2;
  RiftRooms[9].MapName := '';
  RiftRooms[9].HasCoordinates := True;
  RiftRooms[9].HasBounds := False;
  RiftSetPoint(RiftRooms[9].Teleport, -119671, -178471, -6752);
  RiftSetPoint(RiftRooms[9].Guardian, -119677, -178686, -6781);
  for J := 0 to 3 do RiftSetPoint(RiftRooms[9].Corners[J], 0, 0, 0);

  for I := 1 to 8 do
  begin
    RiftRooms[I].MapName := 'r60_' + IntToStr(I) + '.zmap';
    RiftRooms[I].Policy := 0;
    RiftRooms[I].HasCoordinates := True;
    RiftRooms[I].HasBounds := True;
  end;

  RiftRooms[1].NpcID := 31895;
  RiftSetPoint(RiftRooms[1].Teleport, -120160, -179457, -6752);
  RiftSetPoint(RiftRooms[1].Guardian, -120153, -179659, -6781);
  RiftSetPoint(RiftRooms[1].Corners[0], -120523, -179336, -6783);
  RiftSetPoint(RiftRooms[1].Corners[1], -120514, -179935, -6752);
  RiftSetPoint(RiftRooms[1].Corners[2], -119844, -179935, -6752);
  RiftSetPoint(RiftRooms[1].Corners[3], -119850, -179327, -6783);

  RiftRooms[2].NpcID := 31894;
  RiftSetPoint(RiftRooms[2].Teleport, -119254, -179440, -6752);
  RiftSetPoint(RiftRooms[2].Guardian, -119270, -179641, -6781);
  RiftSetPoint(RiftRooms[2].Corners[0], -119640, -179331, -6752);
  RiftSetPoint(RiftRooms[2].Corners[1], -119629, -179934, -6752);
  RiftSetPoint(RiftRooms[2].Corners[2], -118942, -179933, -6783);
  RiftSetPoint(RiftRooms[2].Corners[3], -118943, -179322, -6762);

  RiftRooms[3].NpcID := 31897;
  RiftSetPoint(RiftRooms[3].Teleport, -117982, -179447, -6752);
  RiftSetPoint(RiftRooms[3].Guardian, -117973, -179631, -6781);
  RiftSetPoint(RiftRooms[3].Corners[0], -118687, -179307, -6783);
  RiftSetPoint(RiftRooms[3].Corners[1], -118679, -179977, -6783);
  RiftSetPoint(RiftRooms[3].Corners[2], -117300, -179956, -6783);
  RiftSetPoint(RiftRooms[3].Corners[3], -117325, -179290, -6783);

  RiftRooms[4].NpcID := 31899;
  RiftSetPoint(RiftRooms[4].Teleport, -117976, -178496, -6752);
  RiftSetPoint(RiftRooms[4].Guardian, -117984, -178707, -6781);
  RiftSetPoint(RiftRooms[4].Corners[0], -118705, -178346, -6783);
  RiftSetPoint(RiftRooms[4].Corners[1], -118678, -179018, -6783);
  RiftSetPoint(RiftRooms[4].Corners[2], -117324, -179004, -6783);
  RiftSetPoint(RiftRooms[4].Corners[3], -117325, -178363, -6783);

  RiftRooms[5].NpcID := 31896;
  RiftSetPoint(RiftRooms[5].Teleport, -116310, -178469, -6752);
  RiftSetPoint(RiftRooms[5].Guardian, -116316, -178691, -6781);
  RiftSetPoint(RiftRooms[5].Corners[0], -117030, -178342, -6783);
  RiftSetPoint(RiftRooms[5].Corners[1], -117036, -179017, -6752);
  RiftSetPoint(RiftRooms[5].Corners[2], -115657, -179031, -6752);
  RiftSetPoint(RiftRooms[5].Corners[3], -115639, -178348, -6752);

  RiftRooms[6].NpcID := 31898;
  RiftSetPoint(RiftRooms[6].Teleport, -119762, -177523, -6752);
  RiftSetPoint(RiftRooms[6].Guardian, -119761, -177745, -6781);
  RiftSetPoint(RiftRooms[6].Corners[0], -120517, -177414, -6752);
  RiftSetPoint(RiftRooms[6].Corners[1], -120480, -178130, -6783);
  RiftSetPoint(RiftRooms[6].Corners[2], -119108, -178114, -6752);
  RiftSetPoint(RiftRooms[6].Corners[3], -119107, -177410, -6752);

  RiftRooms[7].NpcID := 31893;
  RiftSetPoint(RiftRooms[7].Teleport, -118475, -177531, -6752);
  RiftSetPoint(RiftRooms[7].Guardian, -118474, -177741, -6781);
  RiftSetPoint(RiftRooms[7].Corners[0], -118842, -177451, -6783);
  RiftSetPoint(RiftRooms[7].Corners[1], -118831, -178039, -6752);
  RiftSetPoint(RiftRooms[7].Corners[2], -118143, -178047, -6783);
  RiftSetPoint(RiftRooms[7].Corners[3], -118175, -177457, -6752);

  RiftRooms[8].NpcID := 31892;
  RiftSetPoint(RiftRooms[8].Teleport, -117618, -177514, -6752);
  RiftSetPoint(RiftRooms[8].Guardian, -117637, -177758, -6781);
  RiftSetPoint(RiftRooms[8].Corners[0], -117945, -177457, -6752);
  RiftSetPoint(RiftRooms[8].Corners[1], -117949, -178045, -6752);
  RiftSetPoint(RiftRooms[8].Corners[2], -117278, -178043, -6783);
  RiftSetPoint(RiftRooms[8].Corners[3], -117289, -177462, -6752);

  // Four separate routes preserve the blank-line groups in rift_60.txt.
  for I := 0 to 3 do
    for J := 0 to 7 do
      RiftSetPoint(RiftRoutes[I].Points[J], 0, 0, 0);
  RiftRoutes[0].Count := 4;
  RiftSetPoint(RiftRoutes[0].Points[0], -115002, -180537, -6783);
  RiftSetPoint(RiftRoutes[0].Points[1], -115210, -180098, -6781);
  RiftSetPoint(RiftRoutes[0].Points[2], -115205, -179046, -6783);
  RiftSetPoint(RiftRoutes[0].Points[3], -115332, -178706, -6781);
  RiftRoutes[1].Count := 4;
  RiftSetPoint(RiftRoutes[1].Points[0], -114400, -180185, -6783);
  RiftSetPoint(RiftRoutes[1].Points[1], -114527, -179664, -6783);
  RiftSetPoint(RiftRoutes[1].Points[2], -114876, -179086, -6781);
  RiftSetPoint(RiftRoutes[1].Points[3], -115316, -178718, -6781);
  RiftRoutes[2].Count := 3;
  RiftSetPoint(RiftRoutes[2].Points[0], -115163, -180244, -6783);
  RiftSetPoint(RiftRoutes[2].Points[1], -115204, -179751, -6783);
  RiftSetPoint(RiftRoutes[2].Points[2], -115327, -178724, -6781);
  RiftRoutes[3].Count := 4;
  RiftSetPoint(RiftRoutes[3].Points[0], -115153, -180275, -6783);
  RiftSetPoint(RiftRoutes[3].Points[1], -115174, -179671, -6783);
  RiftSetPoint(RiftRoutes[3].Points[2], -115018, -179001, -6783);
  RiftSetPoint(RiftRoutes[3].Points[3], -115316, -178713, -6781);
end;

// Rift 50 dataset. Entry requirement was captured as 24 items (ID 7079).
procedure RiftLoad50;
var I, J: Integer;
begin
  RiftLevel := 50;
  RiftEntryItemCount := 24;
  RiftEntryNpcID := 31489;
  RiftBossNpcID := 31882;
  // Rift 50 shares the lobby with the 60/70 datasets. Use the captured final
  // point of route 1 as the party-entry reference; route 2 ends 23 units away.
  RiftSetPoint(RiftLobbyTeleport, -114796, -179334, -6752);
  RiftSetPoint(RiftEntry, -114242, -178701, -6781);
  // One approximate exit point was captured; use it for either exit branch.
  RiftSetPoint(RiftExits[0], -114793, -180754, -6781);
  RiftSetPoint(RiftExits[1], -114793, -180754, -6781);

  // RB has no recorded spawn or approach point. Its polygon identifies the room;
  // HasCoordinates=False makes the controller target NPC 31882 and use its live position.
  RiftRooms[9].NpcID := RiftBossNpcID;
  RiftRooms[9].Policy := 2;
  RiftRooms[9].MapName := '';
  RiftRooms[9].HasCoordinates := False;
  RiftRooms[9].HasBounds := True;
  RiftSetPoint(RiftRooms[9].Teleport, 0, 0, -6752);
  RiftSetPoint(RiftRooms[9].Guardian, 0, 0, -6752);
  RiftSetPoint(RiftRooms[9].Corners[0], -110660, -179129, -6752);
  RiftSetPoint(RiftRooms[9].Corners[1], -109141, -179116, -6752);
  RiftSetPoint(RiftRooms[9].Corners[2], -109117, -178278, -6752);
  RiftSetPoint(RiftRooms[9].Corners[3], -110660, -178253, -6752);

  for I := 1 to 8 do
  begin
    RiftRooms[I].MapName := 'r50_' + IntToStr(I) + '.zmap';
    RiftRooms[I].Policy := 0;
    RiftRooms[I].HasCoordinates := True;
    RiftRooms[I].HasBounds := True;
  end;

  RiftRooms[1].NpcID := 31874;
  RiftSetPoint(RiftRooms[1].Teleport, -111970, -179396, -6752);
  RiftSetPoint(RiftRooms[1].Guardian, -111977, -179593, -6781);
  RiftSetPoint(RiftRooms[1].Corners[0], -112328, -179906, -6752);
  RiftSetPoint(RiftRooms[1].Corners[1], -111609, -179911, -6752);
  RiftSetPoint(RiftRooms[1].Corners[2], -111607, -179346, -6752);
  RiftSetPoint(RiftRooms[1].Corners[3], -112322, -179319, -6752);

  RiftRooms[2].NpcID := 31875;
  RiftSetPoint(RiftRooms[2].Teleport, -111086, -179399, -6752);
  RiftSetPoint(RiftRooms[2].Guardian, -111111, -179617, -6781);
  RiftSetPoint(RiftRooms[2].Corners[0], -111454, -179913, -6752);
  RiftSetPoint(RiftRooms[2].Corners[1], -110718, -179911, -6752);
  RiftSetPoint(RiftRooms[2].Corners[2], -110708, -179314, -6783);
  RiftSetPoint(RiftRooms[2].Corners[3], -111456, -179314, -6752);

  RiftRooms[3].NpcID := 31880;
  RiftSetPoint(RiftRooms[3].Teleport, -109781, -179414, -6752);
  RiftSetPoint(RiftRooms[3].Guardian, -109772, -179594, -6781);
  RiftSetPoint(RiftRooms[3].Corners[0], -109031, -179962, -6783);
  RiftSetPoint(RiftRooms[3].Corners[1], -109105, -179216, -6752);
  RiftSetPoint(RiftRooms[3].Corners[2], -110537, -179273, -6752);
  RiftSetPoint(RiftRooms[3].Corners[3], -110472, -180022, -6752);

  RiftRooms[4].NpcID := 31878;
  RiftSetPoint(RiftRooms[4].Teleport, -113287, -178495, -6752);
  RiftSetPoint(RiftRooms[4].Guardian, -113285, -178667, -6781);
  RiftSetPoint(RiftRooms[4].Corners[0], -113996, -179024, -6752);
  RiftSetPoint(RiftRooms[4].Corners[1], -113942, -178273, -6783);
  RiftSetPoint(RiftRooms[4].Corners[2], -112536, -178356, -6752);
  RiftSetPoint(RiftRooms[4].Corners[3], -112577, -179102, -6752);

  RiftRooms[5].NpcID := 31881;
  RiftSetPoint(RiftRooms[5].Teleport, -111570, -178879, -6752);
  RiftSetPoint(RiftRooms[5].Guardian, -111577, -178727, -6781);
  RiftSetPoint(RiftRooms[5].Corners[0], -110842, -179040, -6752);
  RiftSetPoint(RiftRooms[5].Corners[1], -110897, -178258, -6783);
  RiftSetPoint(RiftRooms[5].Corners[2], -112258, -178285, -6783);
  RiftSetPoint(RiftRooms[5].Corners[3], -112268, -179108, -6783);

  RiftRooms[6].NpcID := 31879;
  RiftSetPoint(RiftRooms[6].Teleport, -111578, -177912, -6752);
  RiftSetPoint(RiftRooms[6].Guardian, -111571, -177756, -6781);
  RiftSetPoint(RiftRooms[6].Corners[0], -110834, -177396, -6752);
  RiftSetPoint(RiftRooms[6].Corners[1], -110902, -178137, -6752);
  RiftSetPoint(RiftRooms[6].Corners[2], -112330, -178072, -6752);
  RiftSetPoint(RiftRooms[6].Corners[3], -112270, -177320, -6783);

  RiftRooms[7].NpcID := 31876;
  RiftSetPoint(RiftRooms[7].Teleport, -110280, -177523, -6752);
  RiftSetPoint(RiftRooms[7].Guardian, -110297, -177727, -6781);
  RiftSetPoint(RiftRooms[7].Corners[0], -110652, -178023, -6752);
  RiftSetPoint(RiftRooms[7].Corners[1], -109915, -178033, -6783);
  RiftSetPoint(RiftRooms[7].Corners[2], -109928, -177452, -6752);
  RiftSetPoint(RiftRooms[7].Corners[3], -110633, -177442, -6752);

  RiftRooms[8].NpcID := 31877;
  RiftSetPoint(RiftRooms[8].Teleport, -109396, -177528, -6752);
  RiftSetPoint(RiftRooms[8].Guardian, -109391, -177690, -6781);
  RiftSetPoint(RiftRooms[8].Corners[0], -109764, -178023, -6752);
  RiftSetPoint(RiftRooms[8].Corners[1], -109056, -178029, -6752);
  RiftSetPoint(RiftRooms[8].Corners[2], -109048, -177465, -6752);
  RiftSetPoint(RiftRooms[8].Corners[3], -109754, -177441, -6752);

  // Clear unused route slots so a future dataset cannot inherit data.
  for I := 0 to 3 do
  begin
    RiftRoutes[I].Count := 0;
    for J := 0 to 7 do RiftSetPoint(RiftRoutes[I].Points[J], 0, 0, 0);
  end;
  RiftRoutes[0].Count := 3;
  RiftSetPoint(RiftRoutes[0].Points[0], -114372, -180129, -6781);
  RiftSetPoint(RiftRoutes[0].Points[1], -114379, -178695, -6781);
  RiftSetPoint(RiftRoutes[0].Points[2], -114242, -178701, -6781);
  RiftRoutes[1].Count := 3;
  RiftSetPoint(RiftRoutes[1].Points[0], -115185, -180273, -6783);
  RiftSetPoint(RiftRoutes[1].Points[1], -115152, -179500, -6783);
  RiftSetPoint(RiftRoutes[1].Points[2], -114228, -178683, -6781);
  // RiftBeginRoute selects one of four slots. Duplicate the two captured
  // routes instead of allowing an empty slot to fall back to a direct path.
  RiftRoutes[2].Count := 3;
  RiftSetPoint(RiftRoutes[2].Points[0], -114372, -180129, -6781);
  RiftSetPoint(RiftRoutes[2].Points[1], -114379, -178695, -6781);
  RiftSetPoint(RiftRoutes[2].Points[2], -114242, -178701, -6781);
  RiftRoutes[3].Count := 3;
  RiftSetPoint(RiftRoutes[3].Points[0], -115185, -180273, -6783);
  RiftSetPoint(RiftRoutes[3].Points[1], -115152, -179500, -6783);
  RiftSetPoint(RiftRoutes[3].Points[2], -114228, -178683, -6781);
end;

procedure RiftLoad70;
var I, J: Integer;
begin
  RiftLevel := 70;
  for I := 1 to 9 do
  begin
    RiftRooms[I].HasCoordinates := True;
    RiftRooms[I].HasBounds := True;
  end;
  RiftEntryItemCount := 33;
  RiftEntryNpcID := 31492;
  RiftBossNpcID := 31909;
  RiftSetPoint(RiftLobbyTeleport, -114796, -179334, -6752);
  RiftSetPoint(RiftEntry, -115317, -181510, -6781);
  RiftSetPoint(RiftExits[0], -114714, -179203, -6752);
  RiftSetPoint(RiftExits[1], -114664, -179305, -6752);

  // RB is always skipped/left; it is never part of GoodRooms or farm maps.
  RiftRooms[9].NpcID := RiftBossNpcID;
  RiftRooms[9].Policy := 2;
  RiftRooms[9].MapName := '';
  RiftSetPoint(RiftRooms[9].Teleport, -119713, -181300, -6752);
  RiftSetPoint(RiftRooms[9].Guardian, -119717, -181515, -6781);
  RiftSetPoint(RiftRooms[9].Corners[0], -120364, -181169, -6783);
  RiftSetPoint(RiftRooms[9].Corners[1], -120356, -181887, -6783);
  RiftSetPoint(RiftRooms[9].Corners[2], -118989, -181847, -6783);
  RiftSetPoint(RiftRooms[9].Corners[3], -119005, -181159, -6783);

  for I := 1 to 8 do
  begin
    RiftRooms[I].MapName := 'r70_' + IntToStr(I) + '.zmap';
    RiftRooms[I].Policy := 0;
  end;

  RiftRooms[1].NpcID := 31904;
  RiftSetPoint(RiftRooms[1].Teleport, -120192, -182286, -6752);
  RiftSetPoint(RiftRooms[1].Guardian, -120170, -182505, -6781);
  RiftSetPoint(RiftRooms[1].Corners[0], -120506, -182166, -6752);
  RiftSetPoint(RiftRooms[1].Corners[1], -120506, -182760, -6783);
  RiftSetPoint(RiftRooms[1].Corners[2], -119828, -182750, -6783);
  RiftSetPoint(RiftRooms[1].Corners[3], -119848, -182162, -6783);

  RiftRooms[2].NpcID := 31903;
  RiftSetPoint(RiftRooms[2].Teleport, -119296, -182269, -6752);
  RiftSetPoint(RiftRooms[2].Guardian, -119323, -182470, -6781);
  RiftSetPoint(RiftRooms[2].Corners[0], -119639, -182179, -6783);
  RiftSetPoint(RiftRooms[2].Corners[1], -119637, -182739, -6752);
  RiftSetPoint(RiftRooms[2].Corners[2], -118942, -182752, -6752);
  RiftSetPoint(RiftRooms[2].Corners[3], -118939, -182162, -6752);

  RiftRooms[3].NpcID := 31906;
  RiftSetPoint(RiftRooms[3].Teleport, -118023, -182276, -6752);
  RiftSetPoint(RiftRooms[3].Guardian, -118023, -182472, -6781);
  RiftSetPoint(RiftRooms[3].Corners[0], -118660, -182171, -6783);
  RiftSetPoint(RiftRooms[3].Corners[1], -118684, -182782, -6782);
  RiftSetPoint(RiftRooms[3].Corners[2], -117310, -182774, -6783);
  RiftSetPoint(RiftRooms[3].Corners[3], -117328, -182110, -6783);

  RiftRooms[4].NpcID := 31908;
  RiftSetPoint(RiftRooms[4].Teleport, -118018, -181325, -6752);
  RiftSetPoint(RiftRooms[4].Guardian, -118003, -181545, -6781);
  RiftSetPoint(RiftRooms[4].Corners[0], -118705, -181162, -6783);
  RiftSetPoint(RiftRooms[4].Corners[1], -118687, -181876, -6783);
  RiftSetPoint(RiftRooms[4].Corners[2], -117304, -181836, -6783);
  RiftSetPoint(RiftRooms[4].Corners[3], -117325, -181156, -6783);

  RiftRooms[5].NpcID := 31905;
  RiftSetPoint(RiftRooms[5].Teleport, -116351, -181298, -6752);
  RiftSetPoint(RiftRooms[5].Guardian, -116384, -181534, -6781);
  RiftSetPoint(RiftRooms[5].Corners[0], -117021, -181175, -6783);
  RiftSetPoint(RiftRooms[5].Corners[1], -117011, -181866, -6774);
  RiftSetPoint(RiftRooms[5].Corners[2], -115642, -181839, -6783);
  RiftSetPoint(RiftRooms[5].Corners[3], -115651, -181157, -6752);

  RiftRooms[6].NpcID := 31907;
  RiftSetPoint(RiftRooms[6].Teleport, -119803, -180352, -6752);
  RiftSetPoint(RiftRooms[6].Guardian, -119800, -180573, -6781);
  RiftSetPoint(RiftRooms[6].Corners[0], -120478, -180233, -6783);
  RiftSetPoint(RiftRooms[6].Corners[1], -120476, -180916, -6783);
  RiftSetPoint(RiftRooms[6].Corners[2], -119103, -180916, -6783);
  RiftSetPoint(RiftRooms[6].Corners[3], -119124, -180249, -6783);

  RiftRooms[7].NpcID := 31902;
  RiftSetPoint(RiftRooms[7].Teleport, -118516, -180359, -6752);
  RiftSetPoint(RiftRooms[7].Guardian, -118519, -180574, -6781);
  RiftSetPoint(RiftRooms[7].Corners[0], -118825, -180287, -6783);
  RiftSetPoint(RiftRooms[7].Corners[1], -118832, -180874, -6783);
  RiftSetPoint(RiftRooms[7].Corners[2], -118149, -180873, -6783);
  RiftSetPoint(RiftRooms[7].Corners[3], -118163, -180287, -6783);

  RiftRooms[8].NpcID := 31901;
  RiftSetPoint(RiftRooms[8].Teleport, -117660, -180342, -6752);
  RiftSetPoint(RiftRooms[8].Guardian, -117673, -180592, -6781);
  RiftSetPoint(RiftRooms[8].Corners[0], -117964, -180274, -6783);
  RiftSetPoint(RiftRooms[8].Corners[1], -117962, -180866, -6752);
  RiftSetPoint(RiftRooms[8].Corners[2], -117262, -180872, -6783);
  RiftSetPoint(RiftRooms[8].Corners[3], -117277, -180277, -6783);

  // Four separate paths, preserving the blank-line groups in rift.txt.
  for I := 0 to 3 do
    for J := 0 to 7 do
      RiftSetPoint(RiftRoutes[I].Points[J], 0, 0, 0);
  RiftRoutes[0].Count := 5;
  RiftSetPoint(RiftRoutes[0].Points[0], -114422, -179922, -6783);
  RiftSetPoint(RiftRoutes[0].Points[1], -114368, -179987, -6783);
  RiftSetPoint(RiftRoutes[0].Points[2], -114420, -180556, -6783);
  RiftSetPoint(RiftRoutes[0].Points[3], -115160, -181311, -6783);
  RiftSetPoint(RiftRoutes[0].Points[4], -115283, -181491, -6781);
  RiftRoutes[1].Count := 6;
  RiftSetPoint(RiftRoutes[1].Points[0], -115071, -179671, -6783);
  RiftSetPoint(RiftRoutes[1].Points[1], -115213, -179943, -6783);
  RiftSetPoint(RiftRoutes[1].Points[2], -115210, -180217, -6783);
  RiftSetPoint(RiftRoutes[1].Points[3], -115239, -181232, -6783);
  RiftSetPoint(RiftRoutes[1].Points[4], -115184, -181412, -6781);
  RiftSetPoint(RiftRoutes[1].Points[5], -115325, -181508, -6781);
  RiftRoutes[2].Count := 2;
  RiftSetPoint(RiftRoutes[2].Points[0], -115212, -180046, -6783);
  RiftSetPoint(RiftRoutes[2].Points[1], -115306, -181528, -6781);
  RiftRoutes[3].Count := 7;
  RiftSetPoint(RiftRoutes[3].Points[0], -114673, -179529, -6781);
  RiftSetPoint(RiftRoutes[3].Points[1], -114423, -179755, -6783);
  RiftSetPoint(RiftRoutes[3].Points[2], -114384, -180092, -6781);
  RiftSetPoint(RiftRoutes[3].Points[3], -114424, -180648, -6783);
  RiftSetPoint(RiftRoutes[3].Points[4], -114819, -180879, -6781);
  RiftSetPoint(RiftRoutes[3].Points[5], -115168, -181498, -6781);
  RiftSetPoint(RiftRoutes[3].Points[6], -115319, -181504, -6781);
end;

// Rift 80 room points, NPCs and paths supplied by the user.
procedure RiftLoad80;
var I, J: Integer;
begin
  RiftLevel := 80;
  RiftEntryItemCount := 36;
  RiftEntryNpcID := 31493;
  RiftBossNpcID := 31918;
  RiftSetPoint(RiftLobbyTeleport, -114796, -179334, -6752);
  // The two route endpoints are 30 units apart; use their midpoint for the
  // party-radius check and exact final approach to the entry NPC.
  RiftSetPoint(RiftEntry, -114797, -182068, -6781);
  // Exit points are the same as the confirmed 70-rift exit points.
  RiftSetPoint(RiftExits[0], -114714, -179203, -6752);
  RiftSetPoint(RiftExits[1], -114664, -179305, -6752);

  for I := 1 to 9 do
  begin
    RiftRooms[I].NpcID := 0;
    RiftRooms[I].MapName := '';
    RiftRooms[I].Policy := 0;
    RiftRooms[I].HasCoordinates := False;
    RiftRooms[I].HasBounds := False;
    RiftSetPoint(RiftRooms[I].Teleport, 0, 0, -6752);
    RiftSetPoint(RiftRooms[I].Guardian, 0, 0, -6781);
    for J := 0 to 3 do RiftSetPoint(RiftRooms[I].Corners[J], 0, 0, -6752);
  end;

  // RB room: identified by its polygon; approach NPC 31918 by live position.
  RiftRooms[9].NpcID := RiftBossNpcID;
  RiftRooms[9].Policy := 2;
  RiftRooms[9].HasBounds := True;
  RiftSetPoint(RiftRooms[9].Corners[0], -115226, -185686, -6752);
  RiftSetPoint(RiftRooms[9].Corners[1], -114359, -185676, -6752);
  RiftSetPoint(RiftRooms[9].Corners[2], -114359, -187183, -6752);
  RiftSetPoint(RiftRooms[9].Corners[3], -115226, -187183, -6752);

  for I := 1 to 8 do
  begin
    RiftRooms[I].MapName := 'r80_' + IntToStr(I) + '.zmap';
    RiftRooms[I].HasBounds := True;
    RiftRooms[I].Policy := 0;
  end;

  // Room 8
  RiftRooms[8].NpcID := 31915;
  RiftRooms[8].HasCoordinates := True;
  RiftSetPoint(RiftRooms[8].Teleport, -114054, -184729, -6752);
  RiftSetPoint(RiftRooms[8].Guardian, -113861, -184755, -6781);
  RiftSetPoint(RiftRooms[8].Corners[0], -113510, -185485, -6752);
  RiftSetPoint(RiftRooms[8].Corners[1], -114188, -185523, -6783);
  RiftSetPoint(RiftRooms[8].Corners[2], -114180, -184011, -6752);
  RiftSetPoint(RiftRooms[8].Corners[3], -113427, -184082, -6752);

  // Room 1
  RiftRooms[1].NpcID := 31916;
  RiftRooms[1].HasCoordinates := True;
  RiftSetPoint(RiftRooms[1].Teleport, -115921, -186487, -6752);
  RiftSetPoint(RiftRooms[1].Guardian, -115741, -186565, -6781);
  RiftSetPoint(RiftRooms[1].Corners[0], -115382, -187301, -6752);
  RiftSetPoint(RiftRooms[1].Corners[1], -116140, -187239, -6783);
  RiftSetPoint(RiftRooms[1].Corners[2], -116062, -185805, -6752);
  RiftSetPoint(RiftRooms[1].Corners[3], -115316, -185876, -6783);

  // Room 3
  RiftRooms[3].NpcID := 31910;
  RiftRooms[3].HasCoordinates := True;
  RiftSetPoint(RiftRooms[3].Teleport, -115932, -184391, -6752);
  RiftSetPoint(RiftRooms[3].Guardian, -115714, -184402, -6781);
  RiftSetPoint(RiftRooms[3].Corners[0], -115430, -184014, -6752);
  RiftSetPoint(RiftRooms[3].Corners[1], -115427, -184750, -6752);
  RiftSetPoint(RiftRooms[3].Corners[2], -116024, -184749, -6752);
  RiftSetPoint(RiftRooms[3].Corners[3], -116019, -184014, -6752);

  // Room 2
  RiftRooms[2].NpcID := 31911;
  RiftRooms[2].HasCoordinates := True;
  RiftSetPoint(RiftRooms[2].Teleport, -115958, -185264, -6752);
  RiftSetPoint(RiftRooms[2].Guardian, -115742, -185248, -6781);
  RiftSetPoint(RiftRooms[2].Corners[0], -115429, -184900, -6752);
  RiftSetPoint(RiftRooms[2].Corners[1], -116032, -184884, -6752);
  RiftSetPoint(RiftRooms[2].Corners[2], -116019, -185631, -6783);
  RiftSetPoint(RiftRooms[2].Corners[3], -115428, -185631, -6752);

  // Room 6
  RiftRooms[6].NpcID := 31913;
  RiftRooms[6].HasCoordinates := True;
  RiftSetPoint(RiftRooms[6].Teleport, -114062, -186920, -6752);
  RiftSetPoint(RiftRooms[6].Guardian, -113871, -186934, -6781);
  RiftSetPoint(RiftRooms[6].Corners[0], -114138, -187301, -6752);
  RiftSetPoint(RiftRooms[6].Corners[1], -113546, -187302, -6752);
  RiftSetPoint(RiftRooms[6].Corners[2], -113543, -186561, -6752);
  RiftSetPoint(RiftRooms[6].Corners[3], -114143, -186563, -6752);

  // Room 4
  RiftRooms[4].NpcID := 31917;
  RiftRooms[4].HasCoordinates := True;
  RiftSetPoint(RiftRooms[4].Teleport, -115007, -184706, -6783);
  RiftSetPoint(RiftRooms[4].Guardian, -114827, -184757, -6781);
  RiftSetPoint(RiftRooms[4].Corners[0], -114450, -185520, -6752);
  RiftSetPoint(RiftRooms[4].Corners[1], -115152, -185500, -6783);
  RiftSetPoint(RiftRooms[4].Corners[2], -115127, -184003, -6752);
  RiftSetPoint(RiftRooms[4].Corners[3], -114391, -184083, -6752);

  // Room 7
  RiftRooms[7].NpcID := 31912;
  RiftRooms[7].HasCoordinates := True;
  RiftSetPoint(RiftRooms[7].Teleport, -114051, -186047, -6752);
  RiftSetPoint(RiftRooms[7].Guardian, -113859, -186078, -6781);
  RiftSetPoint(RiftRooms[7].Corners[0], -113538, -186427, -6783);
  RiftSetPoint(RiftRooms[7].Corners[1], -113544, -185692, -6752);
  RiftSetPoint(RiftRooms[7].Corners[2], -114148, -185678, -6783);
  RiftSetPoint(RiftRooms[7].Corners[3], -114144, -186427, -6783);

  // Room 5 has no supplied TP/guardian points. Its bounds still identify it;
  // guardian movement uses NPC 31914's current position.
  RiftRooms[5].NpcID := 31914;
  RiftSetPoint(RiftRooms[5].Corners[0], -114363, -183819, -6752);
  RiftSetPoint(RiftRooms[5].Corners[1], -115236, -183855, -6752);
  RiftSetPoint(RiftRooms[5].Corners[2], -115236, -182294, -6752);
  RiftSetPoint(RiftRooms[5].Corners[3], -114365, -182294, -6752);

  for I := 0 to 3 do
  begin
    RiftRoutes[I].Count := 0;
    for J := 0 to 7 do RiftSetPoint(RiftRoutes[I].Points[J], 0, 0, 0);
  end;
  RiftRoutes[0].Count := 2;
  RiftSetPoint(RiftRoutes[0].Points[0], -115199, -180071, -6781);
  RiftSetPoint(RiftRoutes[0].Points[1], -114812, -182067, -6781);
  RiftRoutes[1].Count := 2;
  RiftSetPoint(RiftRoutes[1].Points[0], -114382, -180095, -6781);
  RiftSetPoint(RiftRoutes[1].Points[1], -114782, -182068, -6781);
  // RiftBeginRoute chooses among four slots; repeat the two supplied routes.
  RiftRoutes[2].Count := 2;
  RiftSetPoint(RiftRoutes[2].Points[0], -115199, -180071, -6781);
  RiftSetPoint(RiftRoutes[2].Points[1], -114812, -182067, -6781);
  RiftRoutes[3].Count := 2;
  RiftSetPoint(RiftRoutes[3].Points[0], -114382, -180095, -6781);
  RiftSetPoint(RiftRoutes[3].Points[1], -114782, -182068, -6781);
end;

function RiftPointDistanceXY(X, Y: Integer; P: TRiftPoint): Double;
var DX, DY: Double;
begin
  DX := X - P.X;
  DY := Y - P.Y;
  Result := Sqrt(DX * DX + DY * DY);
end;

function RiftNear(X, Y, Z: Integer; P: TRiftPoint;
  XYRadius, ZTolerance: Integer): Boolean;
begin
  Result := (Abs(Z - P.Z) <= ZTolerance) and
    (RiftPointDistanceXY(X, Y, P) <= XYRadius);
end;

// Spawn coordinates are rectangular +/-100 bounds, NOT a radius-100 circle.
// An overlap is deliberately unknown (0), never selected by iteration order.
function RiftDetectSpawnRoom(X, Y, Z: Integer): Integer;
var I, Found: Integer;
begin
  Found := 0;
  Result := 0;
  for I := 1 to 9 do
    if RiftRooms[I].HasCoordinates and
       (Abs(X - RiftRooms[I].Teleport.X) <= 100) and
       (Abs(Y - RiftRooms[I].Teleport.Y) <= 100) and
       (Abs(Z - RiftRooms[I].Teleport.Z) <= 150) then
    begin
      if Found <> 0 then Exit;
      Found := I;
    end;
  Result := Found;
end;

// Exact XY polygon containment with the recorded four edges included.
function RiftPointInRoomXY(RoomIndex, X, Y: Integer): Boolean;
var I, J: Integer; AX, AY, BX, BY, Cross, Dot, EdgeSquared: Double;
begin
  Result := False;
  if not RiftRooms[RoomIndex].HasBounds then Exit;
  J := 3;
  for I := 0 to 3 do
  begin
    AX := RiftRooms[RoomIndex].Corners[J].X;
    AY := RiftRooms[RoomIndex].Corners[J].Y;
    BX := RiftRooms[RoomIndex].Corners[I].X;
    BY := RiftRooms[RoomIndex].Corners[I].Y;
    Cross := (X - AX) * (BY - AY) - (Y - AY) * (BX - AX);
    Dot := (X - AX) * (BX - AX) + (Y - AY) * (BY - AY);
    EdgeSquared := (BX - AX) * (BX - AX) + (BY - AY) * (BY - AY);
    if (Cross = 0) and (Dot >= 0) and (Dot <= EdgeSquared) then
    begin
      Result := True;
      Exit;
    end;
    if ((AY > Y) <> (BY > Y)) then
      if X < AX + (BX - AX) * (Y - AY) / (BY - AY) then
        Result := not Result;
    J := I;
  end;
end;

// Uses recorded polygons only; rooms without corners use spawn/context detection.
// Height range includes every corner, teleport and guardian, plus +/-150.
// Overlapping room polygons return 0, as do points outside the exact polygons.
function RiftContainingRoom(X, Y, Z: Integer): Integer;
var I, J, Found, MinZ, MaxZ: Integer;
begin
  Result := 0;
  Found := 0;
  for I := 1 to 9 do
  begin
    if not RiftRooms[I].HasBounds then Continue;
    MinZ := RiftRooms[I].Teleport.Z;
    MaxZ := MinZ;
    if RiftRooms[I].Guardian.Z < MinZ then MinZ := RiftRooms[I].Guardian.Z;
    if RiftRooms[I].Guardian.Z > MaxZ then MaxZ := RiftRooms[I].Guardian.Z;
    for J := 0 to 3 do
    begin
      if RiftRooms[I].Corners[J].Z < MinZ then MinZ := RiftRooms[I].Corners[J].Z;
      if RiftRooms[I].Corners[J].Z > MaxZ then MaxZ := RiftRooms[I].Corners[J].Z;
    end;
    if (Z >= MinZ - 150) and (Z <= MaxZ + 150) then
      if RiftPointInRoomXY(I, X, Y) then
      begin
        if Found <> 0 then Exit;
        Found := I;
      end;
  end;
  Result := Found;
end;

// Capsule around an XY segment; expected Z is interpolated along the segment.
function RiftNearSegment(X, Y, Z: Integer; A, B: TRiftPoint;
  XYRadius, ZTolerance: Integer): Boolean;
var DX, DY, PX, PY, T, LengthSquared, ExpectedZ: Double;
begin
  DX := B.X - A.X;
  DY := B.Y - A.Y;
  LengthSquared := DX * DX + DY * DY;
  T := 0;
  if LengthSquared > 0 then
    T := ((X - A.X) * DX + (Y - A.Y) * DY) / LengthSquared;
  if T < 0 then T := 0;
  if T > 1 then T := 1;
  PX := X - (A.X + T * DX);
  PY := Y - (A.Y + T * DY);
  ExpectedZ := A.Z + T * (B.Z - A.Z);
  Result := (PX * PX + PY * PY <= XYRadius * XYRadius) and
    (Abs(Z - ExpectedZ) <= ZTolerance);
end;

// Lobby membership includes the known points and the complete path corridors.
// Radius 220 includes the path corridors and independent +/-75 XY jitter.
// Teleport and exit circles overlap: use session/teleport history to detect exit.
function RiftIsLobby(X, Y, Z: Integer): Boolean;
var I, J, K: Integer; Previous: TRiftPoint;
begin
  Result := True;
  if RiftNear(X, Y, Z, RiftLobbyTeleport, 220, 150) then Exit;
  if RiftNear(X, Y, Z, RiftEntry, 220, 150) then Exit;
  for I := 0 to 1 do
    if RiftNear(X, Y, Z, RiftExits[I], 220, 150) then Exit;
  for I := 0 to 3 do
  begin
    // Routes can also start at an exit, which may be far from the lobby TP.
    if RiftRoutes[I].Count > 0 then
      for K := 0 to 1 do
        if RiftNearSegment(X, Y, Z, RiftExits[K], RiftRoutes[I].Points[0], 220, 150) then Exit;
    Previous := RiftLobbyTeleport;
    for J := 0 to RiftRoutes[I].Count - 1 do
    begin
      if RiftNearSegment(X, Y, Z, Previous, RiftRoutes[I].Points[J], 220, 150) then Exit;
      Previous := RiftRoutes[I].Points[J];
    end;
    if RiftNearSegment(X, Y, Z, Previous, RiftEntry, 220, 150) then Exit;
  end;
  Result := False;
end;


const
  RIFT_BUILD_ID = 'rift-ignore-18296-v14';
  RIFT_LOOP_MS = 500;
  RIFT_STATUS_CHECK_MS = 3000;
  RIFT_GOOD_ROOM_CHECK_MS = 5000;
  RIFT_LOGIN_DELAY_MS = 2500;
  RIFT_TELEPORT_SETTLE_MS = 1500;
  RIFT_COMBAT_WAIT_TIMEOUT_MS = 120000;
  RIFT_CURRENT_ROOM_EDGE_MARGIN = 185;
  RIFT_MOVE_TIMEOUT_MS = 30000;
  RIFT_MOVE_RETRY_MS = 1500;
  RIFT_POINT_RADIUS = 80;
  RIFT_PARTY_RADIUS = 500;
  RIFT_PARTY_CHECK_MS = 3000;
  RIFT_ENTRY_RETRY_MS = 5000;            // Captured menu_select entry for rifts 50 and 60.
  RIFT_NPC_TARGET_WAIT_MS = 3000;
  RIFT_ROUTE_JITTER = 75;
  RIFT_ROOM_EXPECTED_MS = 480000;        // telemetry only, never a skip timer

type
  TRiftState = (rsOffline, rsLocate, rsPrepare, rsRoute, rsParty,
    rsWaitTeleport, rsStartFarm, rsFarm, rsGuardian, rsRoomDialog,
    rsExitDelay, rsStopped);
  TRiftRoomAction = (raNone, raSkip, raLeave);
  TRiftPrepStep = (rpWaitCombat, rpBuffOpen, rpBuffApply, rpBuffWait,
    rpSupplies, rpComplete);
  TRiftDialogContext = record
    SessionSerial, TeleportSerial, UserTeleport, TargetOID: Cardinal;
  end;

var
  FarmRiftLevel: Integer;
  MaxMobHP: Integer;
  GoodRooms: TRiftIntegerArray;
  FarmBadRoomsWhileWaiting: Boolean;
  BuffBook: string;
  MapDirectory: string;
  SupplyList: TRiftConsumableArray;
  RState: TRiftState;
  RPrep: TRiftPrepStep;
  RAction, RPendingAction: TRiftRoomAction;
  RInside, RSkipUsed, RRunKnown, ROnline, RExpDone: Boolean;
  RPendingTeleport: Boolean;
  RWasOnline, RHasActor, RMoveActive, RRoomTimerReported: Boolean;
  RHalted, REventsEnabled, REntryArmed, REntryPending, RCombatReady: Boolean;
  RApiFault, RSupplySettingsLogged: Boolean;
  RCombatWaitExpired: Boolean;
  RRunLeaderHere: Boolean;
  RWaitingGoodRoom, RSkipPostponed: Boolean;
  RGoodRoomCheckTick: Cardinal;
  RDiagStage: string;
  RSessionSerial, RTeleportSerial: Cardinal;
  RPartyWaitReason, RPartyLogText: string;
  RTargetCheck: string;
  RPartyCheckTick: Cardinal;
  REntryAttemptTick: Cardinal;
  RIdentityCheckTick, RRunPartyCheckTick: Cardinal;
  RActor, RRunLeaderOID: Cardinal;
  RActorName, RRunLeaderName: string;
  RSeenSession, RSeenTeleport, RSeenUserTeleport: Cardinal;
  RSessionTick, RStateTick, RPrepTick, RTeleportTick, RRoomTick: Cardinal;
  RMoveTick, RLastMoveTick, RExitDelay: Cardinal;
  RRoom, RRoomVisits, RRouteIndex, RRoutePoint: Integer;
  RRouteCount: Integer;
  RMoveTarget: TRiftPoint;
  RRoutePoints: array[0..8] of TRiftPoint;

procedure RiftLog(S: string);
begin
  Print('[RIFT] ' + S);
end;

function RiftElapsed(Since: Cardinal): Cardinal;
begin
  Result := GetTickCount - Since;
end;

function RiftOnline: Boolean;
begin
  Result := False;
  if Engine.Status <> lsOnline then Exit;
  if User = nil then Exit;
  Result := User.OID <> 0;
end;

// Cooperative weapon guard, adapted from room_farm/farm_inventory.pas.
// Initialize once per script run; keep the remembered weapon across room changes.
// Keep only scalar identity between ticks; never retain a live inventory item.

const
  RIFT_WEAPON_POLL_MS = 2000;
  RIFT_WEAPON_STARTUP_RETRY_MS = 1000;
  RIFT_WEAPON_REFRESH_MS = 1500;
  RIFT_WEAPON_WARN_MS = 15000;

var
  RiftWeaponOID, RiftWeaponID: Cardinal;
  RiftWeaponCheckedAt, RiftWeaponRefreshAt, RiftWeaponWarnedAt: Cardinal;
  RiftWeaponStartupCheckedAt: Cardinal;
  RiftWeaponSession, RiftWeaponTeleport, RiftWeaponUserTeleport: Cardinal;
  RiftWeaponActor: Cardinal;
  RiftWeaponPolled, RiftWeaponRefreshing, RiftWeaponWarned: Boolean;
  RiftWeaponStartupPolled, RiftWeaponRemembered, RiftWeaponContextKnown: Boolean;

procedure RiftWeaponWarn(const MessageText: string);
begin
  if RiftWeaponWarned then
    if RiftElapsed(RiftWeaponWarnedAt) < RIFT_WEAPON_WARN_MS then Exit;
  RiftWeaponWarned := True;
  RiftWeaponWarnedAt := GetTickCount;
  RiftLog('Weapon guard: ' + MessageText);
end;

function RiftWeaponInventoryAvailable: Boolean;
begin
  Result := False;
  if not RiftOnline then Exit;
  if not User.Valid then Exit;
  if Inventory = nil then Exit;
  if Inventory.User = nil then Exit;
  Result := True;
end;

function RiftWeaponSnapshotActive(Session, Teleport, UserTeleport,
  Actor: Cardinal): Boolean;
begin
  Result := False;
  if not RiftWeaponInventoryAvailable then Exit;
  if RPendingTeleport then Exit;
  if RSessionSerial <> Session then Exit;
  if RTeleportSerial <> Teleport then Exit;
  if User.TeleportTime <> UserTeleport then Exit;
  if User.OID <> Actor then Exit;
  Result := True;
end;

function RiftWeaponActionReady: Boolean;
begin
  Result := False;
  if not RiftOnline then Exit;
  if not User.Valid then Exit;
  if User.Dead then Exit;
  if RHalted or RApiFault then Exit;
  if not RWasOnline or not RHasActor then Exit;
  if RActor <> User.OID then Exit;
  if RPendingTeleport then Exit;
  if RSessionSerial <> RSeenSession then Exit;
  if RTeleportSerial <> RSeenTeleport then Exit;
  if User.TeleportTime <> RSeenUserTeleport then Exit;
  Result := True;
end;

procedure RiftWeaponRememberStartup;
var
  I, Limit: Integer;
  Item: TL2Item;
  StartupOID, StartupID, Session, Teleport, UserTeleport, Actor: Cardinal;
begin
  if RiftWeaponRemembered then Exit;
  try
    // Reading startup equipment is allowed while dead; equipping is not.
    if not RiftOnline then
    begin RiftWeaponStartupPolled := False; Exit; end;
    if not User.Valid then
    begin RiftWeaponStartupPolled := False; Exit; end;
    if RPendingTeleport then Exit;
    if RiftWeaponStartupPolled then
      if RiftElapsed(RiftWeaponStartupCheckedAt) < RIFT_WEAPON_STARTUP_RETRY_MS then Exit;
    RiftWeaponStartupPolled := True;
    RiftWeaponStartupCheckedAt := GetTickCount;
    if not RiftWeaponInventoryAvailable then Exit;
    Session := RSessionSerial; Teleport := RTeleportSerial;
    UserTeleport := User.TeleportTime; Actor := User.OID;
    Limit := Inventory.User.Count;
    if Limit <= 0 then
    begin
      RiftWeaponWarn('startup inventory is empty; waiting to remember the equipped weapon.');
      Exit;
    end;
    StartupOID := 0; StartupID := 0;
    for I := 0 to Limit - 1 do
    begin
      if not RiftWeaponSnapshotActive(Session, Teleport, UserTeleport, Actor) then Exit;
      if I >= Inventory.User.Count then Exit;
      Item := Inventory.User.Items(I);
      if Item = nil then Exit;
      if not Item.Valid then Exit;
      if StartupOID <> 0 then Continue;
      if not Item.Equipped then Continue;
      if Item.OID = 0 then Continue;
      if (Item.BodyPart and ($80 or $4000)) = 0 then Continue;
      StartupOID := Item.OID; StartupID := Item.ID;
    end;
    if not RiftWeaponSnapshotActive(Session, Teleport, UserTeleport, Actor) then Exit;
    if Limit <> Inventory.User.Count then Exit;
    // Lock an empty-handed startup too. Do not adopt a later weapon.
    RiftWeaponOID := StartupOID; RiftWeaponID := StartupID;
    RiftWeaponRemembered := True;
    if RiftWeaponOID = 0 then
      RiftLog('Weapon guard: no equipped weapon at startup; restart with a weapon equipped to enable it.')
    else
      RiftLog('Weapon guard: remembered startup item ' + IntToStr(RiftWeaponID) +
        ', OID ' + IntToStr(RiftWeaponOID) + '.');
  except
    RiftWeaponWarn('startup inventory is unavailable; waiting to remember the equipped weapon.');
  end;
end;

procedure RiftWeaponInit;
begin
  RiftWeaponOID := 0; RiftWeaponID := 0;
  RiftWeaponCheckedAt := 0; RiftWeaponRefreshAt := 0; RiftWeaponWarnedAt := 0;
  RiftWeaponStartupCheckedAt := 0;
  RiftWeaponSession := 0; RiftWeaponTeleport := 0;
  RiftWeaponUserTeleport := 0; RiftWeaponActor := 0;
  RiftWeaponPolled := False; RiftWeaponRefreshing := False;
  RiftWeaponWarned := False; RiftWeaponStartupPolled := False;
  RiftWeaponRemembered := False; RiftWeaponContextKnown := False;
  RiftWeaponRememberStartup;
end;

function RiftWeaponFind(Session, Teleport, UserTeleport, Actor: Cardinal): TL2Item;
var I, Limit: Integer; Item: TL2Item;
begin
  Result := nil;
  if RiftWeaponOID = 0 then Exit;
  if not RiftWeaponSnapshotActive(Session, Teleport, UserTeleport, Actor) then Exit;
  Limit := Inventory.User.Count;
  for I := 0 to Limit - 1 do
  begin
    if not RiftWeaponSnapshotActive(Session, Teleport, UserTeleport, Actor) then Exit;
    if I >= Inventory.User.Count then Exit;
    Item := Inventory.User.Items(I);
    if Item = nil then Continue;
    if not Item.Valid then Continue;
    if Item.OID <> RiftWeaponOID then Continue;
    if Item.ID <> RiftWeaponID then Continue;
    if (Item.BodyPart and ($80 or $4000)) = 0 then Continue;
    Result := Item;
    Exit;
  end;
end;

procedure RiftWeaponTick;
var Item: TL2Item; Session, Teleport, UserTeleport, Actor: Cardinal;
begin
  try
    RiftWeaponRememberStartup;
    if not RiftWeaponActionReady then
    begin
      // Keep the startup identity across reconnects, discard pending API work.
      RiftWeaponRefreshing := False; RiftWeaponPolled := False;
      RiftWeaponContextKnown := False;
      Exit;
    end;
    if not RiftWeaponRemembered then Exit;
    if RiftWeaponOID = 0 then Exit;
    Session := RSessionSerial; Teleport := RTeleportSerial;
    UserTeleport := User.TeleportTime; Actor := User.OID;
    if not RiftWeaponContextKnown or (RiftWeaponSession <> Session) or
      (RiftWeaponTeleport <> Teleport) or (RiftWeaponUserTeleport <> UserTeleport) or
      (RiftWeaponActor <> Actor) then
    begin
      RiftWeaponRefreshing := False; RiftWeaponPolled := False;
      RiftWeaponSession := Session; RiftWeaponTeleport := Teleport;
      RiftWeaponUserTeleport := UserTeleport; RiftWeaponActor := Actor;
      RiftWeaponContextKnown := True;
    end;
    if RiftWeaponRefreshing then
    begin
      if RiftElapsed(RiftWeaponRefreshAt) < RIFT_WEAPON_REFRESH_MS then Exit;
    end
    else if RiftWeaponPolled then
      if RiftElapsed(RiftWeaponCheckedAt) < RIFT_WEAPON_POLL_MS then Exit;
    RiftWeaponPolled := True; RiftWeaponCheckedAt := GetTickCount;
    Item := RiftWeaponFind(Session, Teleport, UserTeleport, Actor);
    if Item <> nil then
    begin
      if not Item.Valid then Item := nil;
    end;
    if Item <> nil then
    begin
      if Item.Equipped then
      begin RiftWeaponRefreshing := False; Exit; end;
    end;
    if not RiftWeaponRefreshing then
    begin
      if not RiftWeaponActionReady then Exit;
      if RSessionSerial <> Session then Exit;
      if RTeleportSerial <> Teleport then Exit;
      if User.TeleportTime <> UserTeleport then Exit;
      if User.OID <> Actor then Exit;
      // Refresh only when the startup weapon is absent from the equipped slot.
      Engine.SendToServer('14');
      RiftWeaponRefreshing := True; RiftWeaponRefreshAt := GetTickCount;
      Exit;
    end;
    RiftWeaponRefreshing := False;
    if Item = nil then
    begin
      RiftWeaponWarn('startup weapon instance not found; retrying without choosing another weapon.');
      Exit;
    end;
    if not RiftWeaponActionReady then Exit;
    if not RiftWeaponSnapshotActive(Session, Teleport, UserTeleport, Actor) then Exit;
    if not Item.Valid then Exit;
    if (Item.OID <> RiftWeaponOID) or (Item.ID <> RiftWeaponID) then Exit;
    // Using an equipped item toggles it off. Recheck immediately before use.
    if Item.Equipped then Exit;
    if not Engine.UseItemOID(RiftWeaponOID, False, False) then
      RiftWeaponWarn('equip request rejected; will retry after refreshing.');
  except
    RiftWeaponRefreshing := False;
    RiftWeaponWarn('inventory/equip operation failed; will retry.');
  end;
end;

// Current bot settings stay in memory. No profile files are read or written.
// Module IDs: 1 attack, 2 heal, 3 buff, 4 events.
const
  RIFT_IGNORED_NPC_ID = 18294;
  RIFT_IGNORED_NPC_ID_2 = 21740;
  RIFT_IGNORED_NPC_ID_3 = 18295;
  RIFT_IGNORED_NPC_ID_4 = 21763;
  RIFT_IGNORED_NPC_ID_5 = 18296;
  RIFT_IGNORED_NPC_ID_6 = 18289; // Rift 50: do not target.
  RIFT_IGNORED_NPC_ID_7 = 21694; // Rift 50: do not target.
  RIFT80_IGNORED_NPC_ID_1 = 21786;
  RIFT80_IGNORED_NPC_ID_2 = 18297;
  RC_TARGET_CONFIRM_MS = 1500;
  RC_TARGET_RETRY_MS = 3000;
  RC_CORPSE_GRACE_MS = 500;
  RC_SWEEP_TIMEOUT_MS = 8000;
  RC_HP_SLOTS = 256;
  RC_RETRY_SLOTS = 16;
  RC_IGNORE_SLOTS = 16;
  RC_IDLE_WAIT_MS = 3000;
  RC_IDLE_MOVE_CHANCE = 40;
  RC_IDLE_NPC_RADIUS = 150;
  RC_IDLE_POINT_ATTEMPTS = 12;

type
  TRiftCombatMode = (rcUnknown, rcPaused, rcTransit, rcResumed);
  TRiftHPBan = record
    OID, ID: Cardinal;
    Name: string;
  end;
  TRiftTargetRetry = record OID, At: Cardinal; end;

var
  RCReady: Boolean;
  RCSelectsTargets: Boolean;
  RCFinishFight: Boolean;
  RCSaved: array[1..4] of Boolean;
  RCAppliedMode: TRiftCombatMode;
  RCZoneRoom: Integer;
  RCZoneSession, RCPendingOID, RCPendingAt, RCFightOID: Cardinal;
  RCOwnerWaitAt, RCOwnerSelectAt: Cardinal;
  RCConflictAt: Cardinal;
  RCConflictCount: Integer;
  RCPursuing: Boolean;
  RCSweepAvailable, RCCorpseWasSweepable: Boolean;
  RCCorpseOID, RCCorpseAt, RCCorpseClearAt, RCCorpseSelectAt: Cardinal;
  RCHighHP: array[0..RC_HP_SLOTS - 1] of TRiftHPBan;
  RCRetries: array[0..RC_RETRY_SLOTS - 1] of TRiftTargetRetry;
  RCHPNext, RCRetryNext, RCLookupIndex: Integer;
  RCIgnoredOIDs: array[0..RC_IGNORE_SLOTS - 1] of Cardinal;
  RCIgnoreNext: Integer;
  RCIdleWaiting, RCIdleRolled, RCIdleMoving: Boolean;
  RCIdleSince: Cardinal;

procedure RCResetIdleWait;
begin
  RCIdleWaiting := False; RCIdleRolled := False; RCIdleSince := 0;
end;

procedure RCResetTargets;
var I: Integer;
begin
  RCResetIdleWait;
  RCIdleMoving := False;
  RCFinishFight := False;
  RCPendingOID := 0; RCPendingAt := 0; RCFightOID := 0;
  RCOwnerWaitAt := 0; RCOwnerSelectAt := 0;
  RCConflictAt := 0; RCConflictCount := 0;
  RCPursuing := False;
  RCCorpseOID := 0; RCCorpseAt := 0; RCCorpseClearAt := 0;
  RCCorpseSelectAt := 0;
  RCCorpseWasSweepable := False;
  RCHPNext := 0; RCRetryNext := 0;
  RCLookupIndex := -1;
  RCIgnoreNext := 0;
  for I := 0 to RC_IGNORE_SLOTS - 1 do RCIgnoredOIDs[I] := 0;
  for I := 0 to RC_HP_SLOTS - 1 do
  begin RCHighHP[I].OID := 0; RCHighHP[I].ID := 0; RCHighHP[I].Name := ''; end;
  for I := 0 to RC_RETRY_SLOTS - 1 do
  begin RCRetries[I].OID := 0; RCRetries[I].At := 0; end;
end;

procedure RiftCombatInvalidate;
begin
  RCAppliedMode := rcUnknown;
  RCZoneRoom := 0;
  RCResetTargets;
end;

procedure RCSetModule(ID: Integer; Active: Boolean);
begin
  RDiagStage := 'modules.set-' + IntToStr(ID);
  // FaceControl's Boolean return is not a documented success indicator.
  if Engine.GetFaceState(ID) = Active then Exit;
  Engine.FaceControl(ID, Active);
  // No synchronous-update guarantee is documented. A delayed update also stops
  // the controller conservatively; do not wait, retry, or cache an unverified mode.
  RDiagStage := 'modules.verify-' + IntToStr(ID) + '-wanted-' + IntToStr(Ord(Active));
  if Engine.GetFaceState(ID) <> Active then
    raise Exception.Create('Module ' + IntToStr(ID) + ' state not applied; wanted=' + IntToStr(Ord(Active)));
end;

function RiftCombatInit: Boolean;
var I: Integer;
begin
  Result := False;
  if RCReady then begin Result := True; Exit; end;
  if not RiftOnline then Exit;
  RiftCombatInvalidate;
  RDiagStage := 'modules.capture';
  for I := 1 to 4 do RCSaved[I] := Engine.GetFaceState(I);
  RCReady := True;
  Result := True;
  RiftLog('Current bot module states saved; attack=' + IntToStr(Ord(RCSaved[1])) +
    '; heal=' + IntToStr(Ord(RCSaved[2])) + '; buff=' + IntToStr(Ord(RCSaved[3])) +
    '; events=' + IntToStr(Ord(RCSaved[4])));
end;

procedure RiftCombatPause;
var I: Integer;
begin
  if not RCReady then Exit;
  if RCAppliedMode = rcPaused then Exit;
  RiftCombatInvalidate;
  for I := 1 to 4 do RCSetModule(I, False);
  RCAppliedMode := rcPaused;
end;

procedure RiftCombatTransit;
begin
  if not RCReady then Exit;
  if RCAppliedMode = rcTransit then Exit;
  RiftCombatInvalidate;
  // No target pursuit or event actions while approaching a guardian/settling TP.
  // Keep healing active in every room, even if it was off at script startup.
  RCSetModule(2, True);
  RCSetModule(1, False);
  RCSetModule(4, False);
  RCSetModule(3, RCSaved[3]);
  RCAppliedMode := rcTransit;
end;

procedure RiftCombatResume;
var I: Integer;
begin
  if not RCReady then Exit;
  if RCAppliedMode = rcResumed then Exit;
  RCAppliedMode := rcUnknown;
  // The leader selects targets; followers use their existing native Assist.
  // Assist must start without a target, otherwise it cannot acquire the leader.
  for I := 3 to 4 do RCSetModule(I, RCSaved[I]);
  RCSetModule(2, True);
  RCSetModule(1, not RCSelectsTargets);
  RCAppliedMode := rcResumed;
  if RCSelectsTargets then
    RiftLog('Combat role: party leader selects targets; enable General -> Manual target search.')
  else
    RiftLog('Combat role: follower; attack and heal ON, targets and skills controlled by the profile Assist.');
end;

function RCCleanupActive(S, T, U, Actor: Cardinal): Boolean;
begin
  Result := False;
  if not RiftOnline then Exit;
  if not User.Valid then Exit;
  if User.Dead then Exit;
  if RPendingTeleport then Exit;
  if User.OID <> Actor then Exit;
  Result := (RSessionSerial = S) and (RTeleportSerial = T) and
    (User.TeleportTime = U);
end;

procedure RiftCombatCleanup;
var S, T, U, Actor: Cardinal; NeedStop: Boolean;
begin
  // Release scripted pursuit when stopping normally; leave support settings.
  try
    if not RiftOnline then Exit;
    if not User.Valid then Exit;
    if RHasActor then
      if User.OID <> RActor then Exit;
    S := RSessionSerial; T := RTeleportSerial; U := User.TeleportTime;
    Actor := User.OID;
    NeedStop := RCPursuing or RCIdleMoving or (RCPendingOID <> 0) or
      ((RCAppliedMode = rcResumed) and not RCSelectsTargets);
    RCSetModule(1, False);
    if not NeedStop then Exit;
    if not RCCleanupActive(S, T, U, Actor) then Exit;
    Engine.StopCasting;
    if not RCCleanupActive(S, T, U, Actor) then Exit;
    Engine.CancelTarget;
    if not RCCleanupActive(S, T, U, Actor) then Exit;
    Engine.DMoveTo(User.X, User.Y, User.Z);
  finally
    RiftCombatInvalidate;
  end;
end;

procedure RiftCombatBindRoom(Number: Integer);
var Sweep: TL2Skill;
begin
  // Called only after a successful LoadZone in the same session/teleport.
  RCResetTargets;
  RCZoneRoom := Number;
  RCZoneSession := RSessionSerial;
  RCSelectsTargets := RRunLeaderHere;
  // Cache skill availability once per loaded room; the profile owns its use.
  Sweep := nil;
  RCSweepAvailable := SkillList.ByID(42, Sweep);
  if Sweep = nil then RCSweepAvailable := False;
end;

function RCContextActive: Boolean;
begin
  Result := False;
  if RHalted or RApiFault or RPendingTeleport then Exit;
  if not RCReady then Exit;
  if RState <> rsFarm then Exit;
  if not RInside then Exit;
  if (RCZoneRoom < 1) or (RCZoneRoom > 8) or (RCZoneRoom <> RRoom) then Exit;
  if RCZoneSession <> RSessionSerial then Exit;
  if RSessionSerial <> RSeenSession then Exit;
  if RTeleportSerial <> RSeenTeleport then Exit;
  if not RiftOnline then Exit;
  if not User.Valid then Exit;
  if User.Dead then Exit;
  if User.OID <> RActor then Exit;
  if User.TeleportTime <> RSeenUserTeleport then Exit;
  Result := True;
end;

function RCSameContext(S, T, U: Cardinal): Boolean;
begin
  Result := False;
  if not RCContextActive then Exit;
  Result := (S = RSessionSerial) and (T = RTeleportSerial) and
    (U = User.TeleportTime);
end;

function RCIsIgnored(Obj: TL2Live): Boolean;
var I: Integer;
begin
  Result := False;
  if Obj = nil then Exit;
  if not Obj.Valid then Exit;
  if Obj.OID = 0 then Exit;
  for I := 0 to RC_IGNORE_SLOTS - 1 do
    if RCIgnoredOIDs[I] = Obj.OID then begin Result := True; Exit; end;
  if (Obj.ID <> RIFT_IGNORED_NPC_ID) and
    (Obj.ID <> RIFT_IGNORED_NPC_ID_2) and
    (Obj.ID <> RIFT_IGNORED_NPC_ID_3) and
    (Obj.ID <> RIFT_IGNORED_NPC_ID_4) and
    (Obj.ID <> RIFT_IGNORED_NPC_ID_5) and
    (Obj.ID <> RIFT_IGNORED_NPC_ID_6) and
    (Obj.ID <> RIFT_IGNORED_NPC_ID_7) and
    not ((RiftLevel = 80) and
      ((Obj.ID = RIFT80_IGNORED_NPC_ID_1) or
       (Obj.ID = RIFT80_IGNORED_NPC_ID_2))) then Exit;
  // Keep observed instance IDs so a stale snapshot cannot select them again.
  RCIgnoredOIDs[RCIgnoreNext] := Obj.OID;
  RCIgnoreNext := (RCIgnoreNext + 1) mod RC_IGNORE_SLOTS;
  Result := True;
end;

procedure RCObserveHP(Obj: TL2Live);
var I, Slot: Integer;
begin
  if Obj = nil then Exit;
  if not Obj.Valid then Exit;
  if Obj.L2Class <> lcNpc then Exit;
  if Obj.OID = 0 then Exit;
  if Obj.Dead then
  begin
    for I := 0 to RC_HP_SLOTS - 1 do
      if RCHighHP[I].OID = Obj.OID then RCHighHP[I].OID := 0;
    Exit;
  end;
  if (Obj.MaxHP <= MaxMobHP) and (Obj.CurHP <= MaxMobHP) then Exit;
  Slot := -1;
  for I := 0 to RC_HP_SLOTS - 1 do
    if RCHighHP[I].OID = Obj.OID then begin Slot := I; Break; end;
  if Slot < 0 then
  begin
    Slot := RCHPNext;
    RCHPNext := (RCHPNext + 1) mod RC_HP_SLOTS;
  end;
  // Keep only scalar evidence. A wounded high-HP instance remains excluded.
  RCHighHP[Slot].OID := Obj.OID;
  RCHighHP[Slot].ID := Obj.ID;
  RCHighHP[Slot].Name := Obj.Name;
end;

function RCHPBlocked(Obj: TL2Live): Boolean;
var I: Integer;
begin
  Result := False;
  for I := 0 to RC_HP_SLOTS - 1 do
    if (RCHighHP[I].OID = Obj.OID) and (RCHighHP[I].ID = Obj.ID) then
      if (RCHighHP[I].Name = '') or (Obj.Name = '') or
        (RCHighHP[I].Name = Obj.Name) then
      begin Result := True; Exit; end;
end;

function RCCurrentOID: Cardinal;
var Target: TL2Live;
begin
  Result := 0;
  if not RCContextActive then Exit;
  Target := User.Target;
  if Target = nil then Exit;
  if not Target.Valid then Exit;
  if RCIsIgnored(Target) then begin Result := Target.OID; Exit; end;
  // User.Target can carry fresh HP before the matching NpcList entry does.
  RCObserveHP(Target);
  Result := Target.OID;
end;

function RCLookupNpc(OID: Cardinal): TL2Npc;
var I, Count: Integer; Mob: TL2Npc;
begin
  Result := nil;
  if OID = 0 then Exit;
  if not RCContextActive then Exit;
  Count := NpcList.Count;
  // Cache only an index hint, never the native object. Validate its OID on
  // every read, since despawns can reorder the list between ticks.
  if (RCLookupIndex >= 0) and (RCLookupIndex < Count) then
  begin
    Mob := nil;
    if RCLookupIndex < NpcList.Count then Mob := NpcList(RCLookupIndex);
    if Mob <> nil then
      if Mob.Valid then
        if Mob.OID = OID then begin Result := Mob; Exit; end;
  end;
  for I := 0 to Count - 1 do
  begin
    if I >= NpcList.Count then Break;
    Mob := NpcList(I);
    if Mob = nil then Continue;
    if not Mob.Valid then Continue;
    if Mob.OID = OID then
    begin RCLookupIndex := I; Result := Mob; Exit; end;
  end;
end;

function RCAllowedMob(Mob: TL2Npc): Boolean;
begin
  Result := False;
  if not RCContextActive then Exit;
  if Mob = nil then Exit;
  if not Mob.Valid then Exit;
  if Mob.OID = 0 then Exit;
  if RCIsIgnored(Mob) then Exit;
  RCObserveHP(Mob);
  if Mob.Dead then Exit;
  if not Mob.Attackable then Exit;
  if Mob.IsPet then Exit;
  if RCHPBlocked(Mob) then Exit;
  // Unknown HP permits selection only. RCTargetAllowed gates all attacks.
  if Mob.MaxHP > MaxMobHP then Exit;
  if Mob.CurHP > MaxMobHP then Exit;
  // The loaded map is authoritative; recorded room corners are approximate.
  // Aggressors have no exception to either the zone or the HP limit.
  Result := Engine.InZone(Mob);
end;

function RCTargetAllowed(OID: Cardinal): Boolean;
var Target: TL2Live; Mob: TL2Npc;
begin
  Result := False;
  if OID = 0 then Exit;
  // An external target change must never replace an unfinished fight/probe.
  if (RCFightOID <> 0) and (OID <> RCFightOID) then Exit;
  if (RCFightOID = 0) and (RCPendingOID <> 0) then
    if OID <> RCPendingOID then Exit;
  if RCCurrentOID <> OID then Exit;
  Target := User.Target;
  if Target = nil then Exit;
  if not Target.Valid then Exit;
  if RCIsIgnored(Target) then Exit;
  if Target.Dead then Exit;
  if Target.L2Class <> lcNpc then Exit;
  if Target.OID <> OID then Exit;
  Mob := RCLookupNpc(OID);
  if not RCAllowedMob(Mob) then Exit;
  if Target.MaxHP > MaxMobHP then Exit;
  if Target.CurHP > MaxMobHP then Exit;
  // The selected target can receive HP before its NPC-list snapshot does.
  // Neither an unknown target nor an unknown list entry alone permits attack.
  Result := (Target.MaxHP > 0) or (Mob.MaxHP > 0);
end;

function RCTargetDeferred(OID: Cardinal): Boolean;
var I: Integer;
begin
  Result := False;
  for I := 0 to RC_RETRY_SLOTS - 1 do
    if RCRetries[I].OID = OID then
    begin
      Result := RiftElapsed(RCRetries[I].At) < RC_TARGET_RETRY_MS;
      Exit;
    end;
end;

procedure RCDeferTarget(OID: Cardinal);
var I: Integer;
begin
  for I := 0 to RC_RETRY_SLOTS - 1 do
    if RCRetries[I].OID = OID then
    begin RCRetries[I].At := GetTickCount; Exit; end;
  RCRetries[RCRetryNext].OID := OID;
  RCRetries[RCRetryNext].At := GetTickCount;
  RCRetryNext := (RCRetryNext + 1) mod RC_RETRY_SLOTS;
end;

function RCCasting: Boolean;
var Cast: TL2Cast;
begin
  Result := False;
  Cast := User.Cast;
  if Cast <> nil then Result := Cast.EndTime <> 0;
end;

function RCProcessCorpse: Integer;
var Target: TL2Live; Mob: TL2Npc; Sweepable, HasTarget, InZone: Boolean;
    S, T, U: Cardinal;
begin
  // 0: ordinary target handling; 1: keep the profile/corpse; 2: clean handoff.
  Result := 0;
  if not RCContextActive then Exit;
  if RCFightOID = 0 then Exit;
  S := RSessionSerial; T := RTeleportSerial; U := User.TeleportTime;
  Target := User.Target;
  if Target <> nil then
  begin
    if not Target.Valid then Target := nil;
    if Target <> nil then
      if Target.OID <> RCFightOID then Target := nil;
    if Target <> nil then
    begin
      if Target.L2Class <> lcNpc then Exit;
      if RCIsIgnored(Target) then Exit;
    end;
  end;
  HasTarget := Target <> nil;
  Mob := RCLookupNpc(RCFightOID);
  if RCIsIgnored(Mob) then Exit;
  if HasTarget then
  begin
    if not Target.Dead then
    begin
      if Mob = nil then Exit;
      if not Mob.Dead then Exit;
    end;
  end
  else
  begin
    Target := Mob;
    if Target <> nil then
      if not Target.Dead then Target := nil;
    // A vanished, previously observed corpse is a normal completion too.
    if Target = nil then
      if RCCorpseOID <> RCFightOID then Exit;
  end;
  if RCCorpseOID <> RCFightOID then
  begin
    RCCorpseOID := RCFightOID;
    RCCorpseAt := GetTickCount;
    RCCorpseClearAt := GetTickCount;
    RCCorpseSelectAt := 0;
    RCCorpseWasSweepable := False;
    // Do not reselect a stale live list entry after User.Target reports death.
    RCDeferTarget(RCFightOID);
  end;
  Sweepable := False; InZone := False;
  if Target <> nil then
  begin
    Sweepable := Target.Sweepable;
    if Mob <> nil then Sweepable := Sweepable or Mob.Sweepable;
    InZone := Engine.InZone(Target);
  end;
  Result := 1;
  if not RCSameContext(S, T, U) then Exit;
  if not HasTarget then
  begin
    // A new live target cannot steal this corpse's Sweep phase.
    RCSetModule(1, False);
    if not RCSameContext(S, T, U) then Exit;
  end;
  Result := 0;
  if RCSweepAvailable and InZone then
  begin
    if Sweepable then
    begin
      RCCorpseWasSweepable := True;
      RCCorpseClearAt := GetTickCount;
    end;
    if RiftElapsed(RCCorpseAt) < RC_SWEEP_TIMEOUT_MS then
    begin
      // Leave attack enabled: Sweeper is already configured in the profile.
      // No target, movement or cast command may preempt that profile action.
      if Sweepable or (RiftElapsed(RCCorpseAt) < RC_CORPSE_GRACE_MS) or
        RCCasting or
        (RCCorpseWasSweepable and (RiftElapsed(RCCorpseClearAt) <= RC_CORPSE_GRACE_MS)) then
      begin
        // A corpse re-selection never enables combat on an unconfirmed target.
        if HasTarget and (RCCorpseSelectAt <> 0) then
        begin
          if Target.Dead then
          begin
            if RCIsIgnored(Target) then Exit;
            RCSetModule(1, True);
            Result := 1;
            if not RCSameContext(S, T, U) then Exit;
            if RCCurrentOID <> RCFightOID then
            begin RCSetModule(1, False); Exit; end;
            if RCIsIgnored(User.Target) then
            begin RCSetModule(1, False); Result := 0; Exit; end;
          end;
        end;
        if not HasTarget and Sweepable then
        begin
          // A temporary heal/support target may still have a finishing cast.
          if RCCasting then begin Result := 1; Exit; end;
          // Restore only this owned corpse if its target was cleared, once.
          if RCCorpseSelectAt = 0 then
          begin
            RCCorpseSelectAt := GetTickCount;
            RCSetModule(1, False);
            Result := 1;
            if not RCSameContext(S, T, U) then Exit;
            if not Target.Valid then Exit;
            if not Target.Dead then Exit;
            if RCIsIgnored(Target) then begin Result := 0; Exit; end;
            Engine.SetTarget(Target);
          end
          else if RiftElapsed(RCCorpseSelectAt) >= RC_TARGET_CONFIRM_MS then Exit;
        end;
        Result := 1; Exit;
      end;
    end
    else if Sweepable then
    begin
      RiftLog('Combat: sweep timeout for OID ' + IntToStr(RCFightOID) + '; continue.');
      RCDeferTarget(RCFightOID);
      Exit;
    end;
  end
  else if Sweepable and RCSweepAvailable then Exit;
  // A cleared target/removed corpse must not interrupt the finishing cast.
  if Target = nil then
    if RCSweepAvailable and (RiftElapsed(RCCorpseAt) < RC_SWEEP_TIMEOUT_MS) then
      if RCCasting then begin Result := 1; Exit; end;
  RCSetModule(1, False);
  Result := 1;
  if not RCSameContext(S, T, U) then Exit;
  RCDeferTarget(RCFightOID);
  RCFightOID := 0; RCPursuing := False; RCPendingOID := 0;
  RCOwnerWaitAt := 0; RCOwnerSelectAt := 0;
  RCCorpseOID := 0;
  // A normal kill needs no CancelTarget/StopCasting/DMoveTo interruption.
  Result := 2;
end;

procedure RCStopTarget;
var S, T, U, ActualOID: Cardinal; NeedStop, StopCast, HardBan: Boolean; Target: TL2Live;
begin
  if not RCContextActive then Exit;
  S := RSessionSerial; T := RTeleportSerial; U := User.TeleportTime;
  ActualOID := RCCurrentOID;
  NeedStop := RCPursuing or (ActualOID <> 0);
  StopCast := False;
  HardBan := False;
  Target := User.Target;
  if Target <> nil then
    if Target.Valid then
    begin
      HardBan := RCIsIgnored(Target) or (Target.MaxHP > MaxMobHP) or
        (Target.CurHP > MaxMobHP) or RCHPBlocked(Target);
      StopCast := (not Target.Dead) or HardBan;
    end;
  RCSetModule(1, False);
  if not RCSameContext(S, T, U) then Exit;
  if not NeedStop then Exit;
  // Do not cancel a valid late acknowledgement received while stopping.
  if RCTargetAllowed(RCCurrentOID) then Exit;
  if not HardBan then
    if Target <> nil then
      if Target.Valid then
      begin
        // A completed corpse or disappeared NPC needs no movement/cast reset.
        if Target.Dead or ((not RCPursuing) and (RCLookupNpc(ActualOID) = nil)) then
        begin
          RCPursuing := False; RCFightOID := 0; RCCorpseOID := 0;
          RCOwnerWaitAt := 0; RCOwnerSelectAt := 0;
          Exit;
        end;
      end;
  // An invalid live target must stop immediately. Normal eligible fights
  // never enter this function, so their casts are not interrupted per tick.
  if StopCast and (RCPursuing or HardBan) then
  begin
    Engine.StopCasting;
    if not RCSameContext(S, T, U) then Exit;
  end;
  if RCCurrentOID <> 0 then Engine.CancelTarget;
  if not RCSameContext(S, T, U) then Exit;
  // No movement command for idle targets or unconfirmed HP probes.
  if RCPursuing then Engine.DMoveTo(User.X, User.Y, User.Z);
  if not RCSameContext(S, T, U) then Exit;
  RCPursuing := False;
  RCFightOID := 0;
  RCOwnerWaitAt := 0; RCOwnerSelectAt := 0;
  RCCorpseOID := 0;
end;

function RCYieldIdleMove: Boolean;
var S, T, U: Cardinal;
begin
  RCResetIdleWait;
  Result := not RCIdleMoving;
  if Result then Exit;
  if not RCContextActive then Exit;
  // Let support casts finish instead of cancelling them to acquire a mob.
  if RCCasting then Exit;
  S := RSessionSerial; T := RTeleportSerial; U := User.TeleportTime;
  RCIdleMoving := False;
  RDiagStage := 'combat.idle-yield';
  Engine.DMoveTo(User.X, User.Y, User.Z);
  Result := RCSameContext(S, T, U);
end;

procedure RCIdleNoTarget;
var I, DX, DY, X, Y, Z: Integer; S, T, U: Cardinal;
begin
  if not RCContextActive then Exit;
  if not RCSelectsTargets or RCFinishFight then Exit;
  if (RCFightOID <> 0) or (RCPendingOID <> 0) or (RCCorpseOID <> 0) or RCPursuing then Exit;
  if not RiftRooms[RCZoneRoom].HasCoordinates then Exit;
  if not RCIdleWaiting then
  begin RCIdleWaiting := True; RCIdleSince := GetTickCount; Exit; end;
  if RCIdleRolled then Exit;
  if RiftElapsed(RCIdleSince) < RC_IDLE_WAIT_MS then Exit;
  if RCCasting then Exit;
  // A miss also consumes this idle episode; never roll again each empty tick.
  RCIdleRolled := True;
  if Random(100) >= RC_IDLE_MOVE_CHANCE then Exit;
  S := RSessionSerial; T := RTeleportSerial; U := User.TeleportTime;
  for I := 1 to RC_IDLE_POINT_ATTEMPTS do
  begin
    DX := Random(2 * RC_IDLE_NPC_RADIUS + 1) - RC_IDLE_NPC_RADIUS;
    DY := Random(2 * RC_IDLE_NPC_RADIUS + 1) - RC_IDLE_NPC_RADIUS;
    if DX * DX + DY * DY > RC_IDLE_NPC_RADIUS * RC_IDLE_NPC_RADIUS then Continue;
    X := RiftRooms[RCZoneRoom].Guardian.X + DX;
    Y := RiftRooms[RCZoneRoom].Guardian.Y + DY;
    Z := RiftRooms[RCZoneRoom].Guardian.Z;
    RDiagStage := 'combat.idle-point';
    if not Engine.InZone(X, Y, Z) then
    begin
      if not RCSameContext(S, T, U) then Exit;
      Continue;
    end;
    if not RCSameContext(S, T, U) then Exit;
    if RCCasting then Exit;
    // Own only this nonblocking walk; the usual combat selector keeps running.
    RCIdleMoving := True;
    RDiagStage := 'combat.idle-move';
    Engine.DMoveTo(X, Y, Z);
    Exit;
  end;
end;

procedure RCEnableTarget(OID: Cardinal);
var S, T, U: Cardinal;
begin
  if not RCTargetAllowed(OID) then Exit;
  RCResetIdleWait;
  if RCIdleMoving then
  begin
    if not RCYieldIdleMove then Exit;
    if not RCTargetAllowed(OID) then Exit;
  end;
  S := RSessionSerial; T := RTeleportSerial; U := User.TeleportTime;
  RCPendingOID := 0;
  if RCFightOID = 0 then
  begin RCConflictAt := 0; RCConflictCount := 0; end;
  RCOwnerSelectAt := 0;
  RCFightOID := OID;
  RCOwnerWaitAt := 0;
  RCCorpseOID := 0;
  RCPursuing := True;
  RCSetModule(1, True);
  if not RCSameContext(S, T, U) then Exit;
  if not RCTargetAllowed(OID) then
    if RCProcessCorpse = 0 then
    begin
      RCSetModule(1, False);
      if not RCSameContext(S, T, U) then Exit;
      if RCCurrentOID = OID then RCStopTarget;
    end;
end;

function RCHandleOwnedTarget: Boolean;
var Mob: TL2Npc; Target: TL2Live; S, T, U: Cardinal;
begin
  Result := RCFightOID <> 0;
  if not Result then Exit;
  if not RCContextActive then Exit;
  S := RSessionSerial; T := RTeleportSerial; U := User.TeleportTime;
  RCSetModule(1, False);
  if not RCSameContext(S, T, U) then Exit;
  // A late reply can restore our target while the module is stopping.
  if RCTargetAllowed(RCFightOID) then
  begin RCEnableTarget(RCFightOID); Exit; end;
  Mob := RCLookupNpc(RCFightOID);
  if Mob <> nil then
    if not RCAllowedMob(Mob) then
    begin
      RCDeferTarget(RCFightOID);
      // Corpse timeout/lost acknowledgement ends a Sweep phase quietly.
      if Mob.Dead and not RCIsIgnored(Mob) then
      begin
        RCFightOID := 0; RCPursuing := False; RCCorpseOID := 0;
        RCOwnerWaitAt := 0; RCOwnerSelectAt := 0;
        Result := False;
        Exit;
      end;
      RCStopTarget;
      // A hard exclusion or finished/expired corpse releases this cycle.
      Result := RCFightOID <> 0;
      Exit;
    end;
  if RCOwnerWaitAt = 0 then RCOwnerWaitAt := GetTickCount;
  // Keep the owner during a missing snapshot or temporary support target.
  // Do not interrupt healing or submit target requests during its cast.
  if RCCasting then Exit;
  if Mob = nil then
  begin
    if RiftElapsed(RCOwnerWaitAt) < RC_TARGET_CONFIRM_MS then Exit;
    RCDeferTarget(RCFightOID);
    RCFightOID := 0; RCPursuing := False; RCCorpseOID := 0;
    RCOwnerWaitAt := 0; RCOwnerSelectAt := 0;
    Exit;
  end;
  if RCCurrentOID = RCFightOID then
  begin
    // HP may temporarily be unknown. Keep ownership, with attack disabled.
    Exit;
  end;
  if RCOwnerSelectAt = 0 then
  begin
    Target := User.Target;
    if Target <> nil then
      if Target.Valid then
        if Target.L2Class = lcNpc then
        begin
          if (RCConflictAt = 0) or (RiftElapsed(RCConflictAt) >= 5000) then
          begin RCConflictAt := GetTickCount; RCConflictCount := 0; end;
          Inc(RCConflictCount);
          if RCConflictCount >= 3 then
          begin
            RiftLog('Combat: another selector keeps replacing the owned mob. Enable General -> Manual target search. Controller stopped.');
            RHalted := True;
            Exit;
          end;
        end;
    RCOwnerSelectAt := GetTickCount;
    if not RCAllowedMob(Mob) then Exit;
    if not RCSameContext(S, T, U) then Exit;
    Engine.SetTarget(Mob);
    if not RCSameContext(S, T, U) then Exit;
    if RCTargetAllowed(RCFightOID) then RCEnableTarget(RCFightOID);
  end
  else if RiftElapsed(RCOwnerSelectAt) >= RC_TARGET_CONFIRM_MS then
  begin
    // Do not fight a second selector by alternating targets every tick.
    RiftLog('Combat: owned target cannot be restored; enable General -> Manual target search. Controller stopped.');
    RHalted := True;
  end;
end;

function RCChooseTarget: Cardinal;
var I, Count: Integer; Mob: TL2Npc; DX, DY, Distance, Best: Double;
begin
  Result := 0;
  if not RCContextActive then Exit;
  Best := 1.0E100;
  Count := NpcList.Count;
  for I := 0 to Count - 1 do
  begin
    if not RCContextActive then Exit;
    if I >= NpcList.Count then Break;
    Mob := NpcList(I);
    if not RCAllowedMob(Mob) then Continue;
    if RCTargetDeferred(Mob.OID) then Continue;
    DX := Mob.X; DX := DX - User.X;
    DY := Mob.Y; DY := DY - User.Y;
    Distance := DX * DX + DY * DY;
    if Distance < Best then
    begin Result := Mob.OID; Best := Distance; end;
  end;
end;

procedure RiftCombatTick;
var OID, S, T, U: Cardinal; Mob: TL2Npc; Corpse: Integer;
begin
  if not RCContextActive then Exit;
  // Native Assist owns the follower's target, attack cycle and Sweep.
  // Do not disable attack while waiting for Assist to acquire its first target.
  if not RCSelectsTargets then Exit;
  if (RCFightOID <> 0) or (RCPendingOID <> 0) or (RCCorpseOID <> 0) or RCFinishFight then
    RCResetIdleWait;
  RDiagStage := 'combat.target';
  Corpse := RCProcessCorpse;
  if Corpse = 1 then Exit;
  if RCFinishFight and (RCFightOID = 0) and (RCPendingOID = 0) then
  begin RCSetModule(1, False); Exit; end;
  OID := RCCurrentOID;
  if RCTargetAllowed(OID) then
  begin
    // Keep the actual eligible target until it dies or becomes forbidden.
    // This fast path does not scan all NPCs or resend SetTarget.
    RCEnableTarget(OID);
    Exit;
  end;
  if RCHandleOwnedTarget then Exit;
  if not RCContextActive then Exit;
  S := RSessionSerial; T := RTeleportSerial; U := User.TeleportTime;
  // Wait for either target acknowledgement or its HP without canceling the
  // selected unknown-HP mob. The attack module stays off throughout the probe.
  if RCPendingOID <> 0 then
  begin
    if not RCAllowedMob(RCLookupNpc(RCPendingOID)) then RCPendingOID := 0
    else if RiftElapsed(RCPendingAt) < RC_TARGET_CONFIRM_MS then
    begin
      // A different actual target is not an acknowledgement of this request.
      RCSetModule(1, False); Exit;
    end
    else
    begin RCDeferTarget(RCPendingOID); RCPendingOID := 0; end;
  end;
  if Corpse <> 2 then RCStopTarget;
  if not RCSameContext(S, T, U) then Exit;
  // An acknowledgement can arrive while the attack module is stopping.
  OID := RCCurrentOID;
  if not RCTargetDeferred(OID) then
    if RCTargetAllowed(OID) then begin RCEnableTarget(OID); Exit; end;
  if RCPendingOID <> 0 then Exit;
  if RCFinishFight then Exit;
  OID := RCChooseTarget;
  if OID = 0 then begin RCIdleNoTarget; Exit; end;
  if not RCYieldIdleMove then Exit;
  Mob := RCLookupNpc(OID);
  if not RCAllowedMob(Mob) then Exit;
  if not RCSameContext(S, T, U) then Exit;
  RCPendingOID := OID; RCPendingAt := GetTickCount;
  RDiagStage := 'combat.select-target';
  // The observed target, not the command Boolean, confirms the request.
  Engine.SetTarget(Mob);
  if not RCSameContext(S, T, U) then Exit;
  if RCTargetAllowed(OID) then RCEnableTarget(OID)
  else
  begin
    // Late HP/zone updates and wrong target acknowledgements cannot enable
    // the attack profile. Keep a valid pending request's original deadline.
    if RCCurrentOID = OID then
      if RCAllowedMob(RCLookupNpc(OID)) then Exit;
    RCStopTarget;
    if not RCSameContext(S, T, U) then Exit;
    if not RCAllowedMob(RCLookupNpc(OID)) then RCPendingOID := 0;
  end;
end;


// Native callbacks replace the separate WaitAction worker.
// Action callbacks record only scalar counters; game actions stay in the main loop.
procedure RiftCoreOnAction(Action: TL2Action; P1, P2: Pointer);
begin
  if REventsEnabled then
    case Action of
      laInGame, laCharSelect: Inc(RSessionSerial);
      laTeleport: Inc(RTeleportSerial);
    end;
  if (Action = laInGame) or (Action = laCharSelect) then
    Consumables.ConsumablesOnAction(Action, P1, P2);
end;

procedure RiftCoreOnFree;
begin
  REventsEnabled := False;
  Consumables.ConsumablesFree;
end;

procedure RiftCancelMotion;
begin
  RMoveActive := False;
  if not RiftOnline then Exit;
  Engine.CancelTarget;
  // There is no documented StopMove call: replace the old destination.
  Engine.DMoveTo(User.X, User.Y, User.Z);
end;

procedure RiftSetState(Value: TRiftState; Reason: string);
begin
  RState := Value;
  RStateTick := GetTickCount;
  RiftLog(Reason);
end;

procedure RiftStop(Reason: string);
begin
  RHalted := True;
  RPendingTeleport := False; REntryArmed := False;
  if RCombatReady and RiftOnline then
  begin
    if RInside then RiftCombatTransit else RiftCombatPause;
  end;
  RiftCancelMotion;
  RiftSetState(rsStopped, 'STOP: ' + Reason);
end;

// After an API exception, do not re-enter Engine/User or switch bot modules.
// The ordinary RiftStop is only for controlled stops, while the API is usable.
procedure RiftFatal;
begin
  RApiFault := True; RHalted := True; REventsEnabled := False;
  RMoveActive := False; RPendingTeleport := False; REntryArmed := False;
  RState := rsStopped;
  try Print('[RIFT] FATAL stage=' + RDiagStage + '; controller ended'); except end;
end;

function RiftConfigure: Boolean;
var I, Room: Integer;
begin
  Result := False;
  if MaxMobHP <= 0 then
  begin RiftLog('MaxMobHP must be greater than zero'); Exit; end;
  // Each supported rift has an internal dataset selected from the launch setting.
  case FarmRiftLevel of
    50: RiftLoad50;
    70: RiftLoad70;
    60: RiftLoad60;
    80: RiftLoad80;
  else
    RiftLog('No internal dataset for rift ' + IntToStr(FarmRiftLevel)); Exit;
  end;
  if RiftEntryItemCount <= 0 then
  begin RiftLog('Entry-item count is not configured for rift ' + IntToStr(RiftLevel)); Exit; end;
  for I := 1 to 8 do RiftRooms[I].Policy := 2;
  for I := 0 to High(GoodRooms) do
  begin
    Room := GoodRooms[I];
    if (Room < 1) or (Room > 8) then
    begin RiftLog('GoodRooms: room numbers must be from 1 to 8'); Exit; end;
    RiftRooms[Room].Policy := 1;
  end;
  Result := True;
end;

// Read configuration only: no inventory, packets or purchases.
function RiftSupplySettingsValid(LogRows: Boolean): Boolean;
var I, Count: Integer; Name: string; Minimum, Maximum: Int64;
begin
  Result := False;
  Count := Length(SupplyList);
  if Count > 200 then
  begin RiftLog('SUPPLIES CONFIG: more than 200 rows'); Exit; end;
  for I := 0 to Count - 1 do
  begin
    Name := Trim(SupplyList[I].Name);
    Minimum := SupplyList[I].Minimum; Maximum := SupplyList[I].Maximum;
    if Name = '' then
    begin
      RiftLog('SUPPLIES CONFIG: SupplyList[' + IntToStr(I) + '].Name is empty; check ConfigureSupplies');
      Exit;
    end;
    if (Minimum < 0) or (Maximum <= Minimum) or (Maximum > 1000000000) then
    begin
      RiftLog('SUPPLIES CONFIG: invalid min/max at SupplyList[' + IntToStr(I) + '] "' + Name + '"');
      Exit;
    end;
    if LogRows then
      RiftLog('SUPPLIES CONFIG [' + IntToStr(I) + ']: "' + Name + '"; min=' +
        IntToStr(Integer(Minimum)) + '; max=' + IntToStr(Integer(Maximum)));
  end;
  Result := True;
end;

function RiftSettingsValid: Boolean;
var I: Integer;
begin
  Result := False;
  if BuffBook = '' then
  begin RiftLog('BuffBook must name the actual Alt+B preset'); Exit; end;
  if MapDirectory = '' then
  begin RiftLog('Set MapDirectory and install the eight zmap files'); Exit; end;
  if not RiftSupplySettingsValid(False) then Exit;
  if MapDirectory[Length(MapDirectory)] <> '\' then MapDirectory := MapDirectory + '\';
  for I := 1 to 8 do
  begin
    if (RiftRooms[I].Policy < 1) or (RiftRooms[I].Policy > 2) then
    begin RiftLog('Set farm/skip policy for room ' + IntToStr(I)); Exit; end;
    // Bad rooms are farmed too while waiting for a selected room to become free.
    if not FileExists(MapDirectory + RiftRooms[I].MapName) then
    begin RiftLog('Missing map: ' + MapDirectory + RiftRooms[I].MapName); Exit; end;
  end;
  Result := True;
end;

function RiftLeader: Boolean;
var Leader: TL2Char;
begin
  Result := False;
  if Party = nil then Exit;
  Leader := Party.Leader;
  if Leader = nil then Exit;
  Result := Leader.OID = User.OID;
end;

function RiftPartyNearby: Boolean;
var I, OtherCount: Integer; Peer, Visible: TL2Char; PeerOID: Cardinal; Obj: TL2Object;
begin
  Result := False;
  RPartyWaitReason := '';
  if Party = nil then
  begin RPartyWaitReason := 'Party data unavailable'; Exit; end;
  if Party.Leader = nil then
  begin RPartyWaitReason := 'Party leader unavailable'; Exit; end;
  if not RiftNear(User.X, User.Y, User.Z, RiftEntry, RIFT_PARTY_RADIUS, 150) then
  begin
    RPartyWaitReason := 'Self outside entry radius: XY=' +
      IntToStr(Round(RiftPointDistanceXY(User.X, User.Y, RiftEntry))) +
      '/' + IntToStr(RIFT_PARTY_RADIUS) + '; dZ=' + IntToStr(Abs(User.Z - RiftEntry.Z)) + '/150';
    Exit;
  end;
  OtherCount := 0; PeerOID := 0;
  for I := 0 to Party.Chars.Count - 1 do
  begin
    Peer := Party.Chars.Items(I);
    if Peer = nil then
    begin RPartyWaitReason := 'Empty party member at index ' + IntToStr(I); Exit; end;
    if Peer.OID <> User.OID then
    begin
      if (Peer.OID = 0) or (Peer.OID = PeerOID) then
      begin RPartyWaitReason := 'Invalid/duplicate party member: ' + Peer.Name; Exit; end;
      Inc(OtherCount); PeerOID := Peer.OID;
      Obj := nil;
      if not CharList.ByOID(PeerOID, Obj) then
      begin RPartyWaitReason := 'Party member not in CharList: ' + Peer.Name; Exit; end;
      if Obj = nil then
      begin RPartyWaitReason := 'Party member not in CharList: ' + Peer.Name; Exit; end;
      if not Obj.Valid then
      begin RPartyWaitReason := 'Party member not Valid: ' + Peer.Name; Exit; end;
      if Obj.L2Class <> lcChar then
      begin RPartyWaitReason := 'Party member object is not a character'; Exit; end;
      Visible := TL2Char(Obj);
      if Visible.Dead then
      begin RPartyWaitReason := 'Party member is dead: ' + Peer.Name; Exit; end;
      if not RiftNear(Visible.X, Visible.Y, Visible.Z, RiftEntry, RIFT_PARTY_RADIUS, 150) then
      begin
        RPartyWaitReason := Peer.Name + ' outside entry radius: XY=' +
          IntToStr(Round(RiftPointDistanceXY(Visible.X, Visible.Y, RiftEntry))) +
          '/' + IntToStr(RIFT_PARTY_RADIUS) + '; dZ=' + IntToStr(Abs(Visible.Z - RiftEntry.Z)) + '/150';
        Exit;
      end;
    end;
  end;
  Result := OtherCount = 1; // independent of whether Party.Chars contains User
  if not Result then RPartyWaitReason := 'Expected one companion; found ' + IntToStr(OtherCount);
end;

procedure RiftResetPartyWait;
begin
  RPartyCheckTick := GetTickCount - RIFT_PARTY_CHECK_MS;
  RPartyLogText := '';
end;

procedure RiftLogPartyWait(Reason: string);
begin
  // Waiting checks repeat, identical log messages do not.
  if RPartyLogText = Reason then Exit;
  RPartyLogText := Reason;
  RiftLog('PARTY WAIT: ' + Reason);
end;

// Entry dialogs depend on the rift level; room dialogs share the same actions.
// Return True ONLY after the final request was sent. Do not wait for TP here.
// Check RSessionSerial/RTeleportSerial between delayed dialog steps.
function RiftTargetNpcOID(NpcID: Cardinal): Cardinal;
var Target: TL2Live; ActualID, ActualOID: Cardinal; ActualClass: Integer;
begin
  Result := 0;
  RTargetCheck := 'expected NPC=' + IntToStr(NpcID);
  Target := User.Target;
  if Target = nil then
  begin RTargetCheck := RTargetCheck + '; target=nil'; Exit; end;
  if not Target.Valid then
  begin RTargetCheck := RTargetCheck + '; target.Valid=False'; Exit; end;
  // Keep scalar diagnostics from this read; never retain the object across Delay.
  ActualClass := Ord(Target.L2Class);
  ActualID := Target.ID; ActualOID := Target.OID;
  RTargetCheck := RTargetCheck + '; actual ID=' + IntToStr(ActualID) +
    '; class=' + IntToStr(ActualClass) + '; OID=' + IntToStr(ActualOID);
  if ActualClass <> Ord(lcNpc) then Exit;
  if ActualID <> NpcID then Exit;
  Result := ActualOID;
end;

function RiftEnterDialog(NpcID: Cardinal): Boolean;
var
  S, T, U, TargetOID, BeforeStamp: Cardinal;
  Command, Caption, Html, BeforeHtml: string;
begin
  Result := False;
  case RiftLevel of
    50:
      begin
        if NpcID <> 31489 then Exit;
        Command := 'menu_select?ask=635&reply=1';
        Caption := 'I want to go to the inner space of the rift.';
      end;
    60:
      begin
        if NpcID <> 31491 then Exit;
        Command := 'menu_select?ask=635&reply=1';
        Caption := 'I want to go to the inner space of the rift.';
      end;
    70:
      begin
        if NpcID <> 31492 then Exit;
        Command := 'menu_select?ask=5000&reply=2';
        Caption := 'Join the queue to enter';
      end;
    80:
      begin
        if NpcID <> 31493 then Exit;
        Command := 'menu_select?ask=5000&reply=2';
        Caption := 'Join the queue to enter';
      end;
  else
    RiftLog('Entry dialog is not captured for rift ' + IntToStr(RiftLevel)); Exit;
  end;
  if not RiftOnline then Exit;
  if RHalted or RInside or RPendingTeleport or not REntryArmed then Exit;
  if not RiftLeader then Exit;
  S := RSessionSerial; T := RTeleportSerial; U := User.TeleportTime;
  if (S <> RSeenSession) or (T <> RSeenTeleport) or (U <> RSeenUserTeleport) then Exit;
  RDiagStage := 'entry.target';
  Engine.SetTargetID(NpcID);
  Delay(500);
  if not RiftOnline then Exit;
  if (S <> RSessionSerial) or (T <> RTeleportSerial) or (U <> User.TeleportTime) then Exit;
  TargetOID := RiftTargetNpcOID(NpcID);
  if TargetOID = 0 then
  begin RiftLog('Entry NPC target unavailable: ' + RTargetCheck); Exit; end;
  BeforeStamp := Engine.DlgTime; BeforeHtml := Engine.DlgText;
  RDiagStage := 'entry.open-dialog';
  Engine.DlgOpen(5000);
  if not RiftOnline then Exit;
  if (S <> RSessionSerial) or (T <> RTeleportSerial) or (U <> User.TeleportTime) then Exit;
  if RiftTargetNpcOID(NpcID) <> TargetOID then
  begin RiftLog('Target changed while opening entry dialog'); Exit; end;
  Html := Engine.DlgText;
  if (Html = '') or ((Engine.DlgTime = BeforeStamp) and (Html = BeforeHtml)) then
  begin RiftLog('Entry NPC did not return a new dialog'); Exit; end;
  // Match the complete captured action, including its closing quote.
  if (Pos('bypass -h ' + Command + '"', Html) = 0) and
    (Pos('bypass -h ' + Command + '''', Html) = 0) then
  begin RiftLog(Caption + ' is not offered in the current dialog'); Exit; end;
  if not RiftOnline then Exit;
  if (S <> RSessionSerial) or (T <> RTeleportSerial) or (U <> User.TeleportTime) then Exit;
  if RHalted or RInside or RPendingTeleport or not REntryArmed then Exit;
  if not RiftLeader then Exit;
  RDiagStage := 'entry.send-' + IntToStr(RiftLevel);
  Result := Engine.BypassToServer(Command);
  if Result then RiftLog(Caption + ': request sent')
  else if (RiftLevel = 50) or (RiftLevel = 60) then
    RiftLog('Rift ' + IntToStr(RiftLevel) + ' entry unconfirmed; retry in 5 seconds unless teleported')
  else RiftLog('Entry queue request was not confirmed; no automatic retry');
end;

procedure RiftAttemptEntry;
var S, T, U: Cardinal; Sent: Boolean;
begin
  if not RiftOnline then Exit;
  if RHalted or RInside or RPendingTeleport or not REntryArmed then Exit;
  S := RSessionSerial; T := RTeleportSerial; U := User.TeleportTime;
  if (S <> RSeenSession) or (T <> RSeenTeleport) or (U <> RSeenUserTeleport) then Exit;
  REntryPending := True;
  // Reserve the waiting state before a blocking dialog can yield to teleport.
  RState := rsWaitTeleport;
  RStateTick := GetTickCount;
  Sent := RiftEnterDialog(RiftEntryNpcID);
  // Time from the completed attempt: no blocking 5-second wait in this method.
  REntryAttemptTick := GetTickCount;
  if not RiftOnline then Exit;
  if (S <> RSessionSerial) or (T <> RTeleportSerial) or (U <> User.TeleportTime) then Exit;
  // A TP/relog during the dialog is handled by the main loop, not a failed entry.
  if (RiftLevel = 50) or (RiftLevel = 60) then
    RiftSetState(rsWaitTeleport, 'Rift ' + IntToStr(RiftLevel) + ': wait for teleport; repeat entry after 5 seconds if needed')
  else if Sent then RiftSetState(rsWaitTeleport, 'Waiting for entry queue teleport')
  else RiftStop('Entry request failed; inspect the preceding log');
end;

procedure RiftTickEntryRetry;
begin
  if (RiftLevel <> 50) and (RiftLevel <> 60) then Exit;
  if not REntryPending or not REntryArmed or RInside or RPendingTeleport or RHalted then Exit;
  if RiftElapsed(REntryAttemptTick) < RIFT_ENTRY_RETRY_MS then Exit;
  if not RiftOnline then Exit;
  if (RSessionSerial <> RSeenSession) or (RTeleportSerial <> RSeenTeleport) then Exit;
  if User.TeleportTime <> RSeenUserTeleport then Exit;
  // Also throttle failed leader/proximity checks while waiting to retry.
  REntryAttemptTick := GetTickCount;
  if not RiftLeader then
  begin RiftLogPartyWait('Rift ' + IntToStr(RiftLevel) + ' entry retry waits for the party leader'); Exit; end;
  if not RiftPartyNearby then
  begin RiftLogPartyWait(RPartyWaitReason); Exit; end;
  RiftAttemptEntry;
end;

function RiftRoomDialogActive(C: TRiftDialogContext): Boolean;
var Target: TL2Live; Leader: TL2Char;
begin
  Result := False;
  if RHalted or RApiFault or RPendingTeleport then Exit;
  if not RiftOnline then Exit;
  if not RInside or not RRunKnown or User.Dead then Exit;
  if not RiftLeader then Exit;
  Leader := Party.Leader;
  if Leader = nil then Exit;
  if Leader.Name <> RRunLeaderName then Exit;
  // Do not start a dialog in a transition the main loop has not handled yet.
  if (RSessionSerial <> RSeenSession) or (RTeleportSerial <> RSeenTeleport) then Exit;
  if User.TeleportTime <> RSeenUserTeleport then Exit;
  if (C.SessionSerial <> RSessionSerial) or (C.TeleportSerial <> RTeleportSerial) then Exit;
  if C.UserTeleport <> User.TeleportTime then Exit;
  if C.TargetOID <> 0 then
  begin
    Target := User.Target;
    if Target = nil then Exit;
    if not Target.Valid then Exit;
    if Target.OID <> C.TargetOID then Exit;
  end;
  Result := True;
end;

// Observe room availability without changing the loaded map or any target.
// A room is free only after its own guardian was observed in a complete scan.

function RiftOccupancyContext(S, T, U, Actor: Cardinal; Room: Integer): Boolean;
begin
  Result := False;
  if RHalted or RApiFault or RPendingTeleport then Exit;
  if not RInside or not RRunKnown then Exit;
  if not RiftOnline then Exit;
  if User = nil then Exit;
  if not User.Valid then Exit;
  if User.Dead then Exit;
  if (Actor = 0) or (User.OID <> Actor) or (RActor <> Actor) then Exit;
  if (RRoom <> Room) or (Room < 1) or (Room > 9) then Exit;
  if (RSessionSerial <> S) or (RSessionSerial <> RSeenSession) then Exit;
  if (RTeleportSerial <> T) or (RTeleportSerial <> RSeenTeleport) then Exit;
  if (User.TeleportTime <> U) or (U <> RSeenUserTeleport) then Exit;
  Result := True;
end;

function RiftOccupancyPointInRoom(Room, X, Y, Z: Integer): Boolean;
var I, J, MinZ, MaxZ: Integer; A, B: TRiftPoint;
begin
  Result := False;
  if (Room < 1) or (Room > 8) then Exit;
  if not RiftRooms[Room].HasBounds then Exit;
  MinZ := RiftRooms[Room].Teleport.Z; MaxZ := MinZ;
  if RiftRooms[Room].Guardian.Z < MinZ then MinZ := RiftRooms[Room].Guardian.Z;
  if RiftRooms[Room].Guardian.Z > MaxZ then MaxZ := RiftRooms[Room].Guardian.Z;
  for I := 0 to 3 do
  begin
    if RiftRooms[Room].Corners[I].Z < MinZ then MinZ := RiftRooms[Room].Corners[I].Z;
    if RiftRooms[Room].Corners[I].Z > MaxZ then MaxZ := RiftRooms[Room].Corners[I].Z;
  end;
  if (Z < MinZ - 150) or (Z > MaxZ + 150) then Exit;
  if RiftPointInRoomXY(Room, X, Y) then begin Result := True; Exit; end;
  // Recorded corners are narrower than farm maps. Include their edge margin.
  J := 3;
  for I := 0 to 3 do
  begin
    A := RiftRooms[Room].Corners[J]; B := RiftRooms[Room].Corners[I];
    // Height was checked against the entire room; the edge margin is XY-only.
    A.Z := 0; B.Z := 0;
    if RiftNearSegment(X, Y, 0, A, B, RIFT_CURRENT_ROOM_EDGE_MARGIN, 0) then
    begin Result := True; Exit; end;
    J := I;
  end;
end;

function RiftOccupancySnapshotActive(S, T, U, Actor: Cardinal;
  Room, Players, Npcs: Integer): Boolean;
begin
  Result := False;
  if not RiftOccupancyContext(S, T, U, Actor, Room) then Exit;
  if CharList.Count <> Players then Exit;
  if NpcList.Count <> Npcs then Exit;
  Result := True;
end;

function RiftFindFreeGoodRoom: Integer;
var
  Busy, GuardianSeen, Selected: array[1..8] of Boolean;
  Player: TL2Char;
  Npc: TL2Npc;
  S, T, U, Actor, NpcID: Cardinal;
  I, Room, CurrentRoom, Players, Npcs, X, Y, Z: Integer;
  Pet, Occupant: Boolean;
begin
  // -1: incomplete/unavailable snapshot; 0: no observed free destination.
  // Native API exceptions propagate to RiftRun's fatal-stop handler.
  Result := -1;
  if not RiftOnline then Exit;
  if User = nil then Exit;
  if not User.Valid then Exit;
  S := RSessionSerial; T := RTeleportSerial; U := User.TeleportTime;
  Actor := User.OID; CurrentRoom := RRoom;
  if not RiftOccupancyContext(S, T, U, Actor, CurrentRoom) then Exit;
  if CurrentRoom = 9 then begin Result := 0; Exit; end;
  for Room := 1 to 8 do
  begin
    Busy[Room] := False; GuardianSeen[Room] := False;
    Selected[Room] := (RiftRooms[Room].Policy = 1) and (Room <> CurrentRoom);
  end;
  Players := CharList.Count; Npcs := NpcList.Count;
  if (Players < 0) or (Npcs < 0) then Exit;
  RDiagStage := 'room-availability.players';
  for I := 0 to Players - 1 do
  begin
    if not RiftOccupancySnapshotActive(S, T, U, Actor, CurrentRoom, Players, Npcs) then Exit;
    Player := CharList(I);
    if Player = nil then Exit;
    if not Player.Valid then Exit;
    if (Player.OID = 0) or (Player.L2Class <> lcChar) then Exit;
    X := Player.X; Y := Player.Y; Z := Player.Z;
    for Room := 1 to 8 do
      if Selected[Room] then
        if RiftOccupancyPointInRoom(Room, X, Y, Z) then Busy[Room] := True;
  end;
  RDiagStage := 'room-availability.npcs';
  for I := 0 to Npcs - 1 do
  begin
    if not RiftOccupancySnapshotActive(S, T, U, Actor, CurrentRoom, Players, Npcs) then Exit;
    Npc := NpcList(I);
    if Npc = nil then Exit;
    if not Npc.Valid then Exit;
    if (Npc.OID = 0) or (Npc.L2Class <> lcNpc) then Exit;
    X := Npc.X; Y := Npc.Y; Z := Npc.Z; NpcID := Npc.ID;
    Pet := Npc.IsPet;
    // Corpses, pets and ignored/high-HP mobs still indicate an occupied room.
    Occupant := Pet or Npc.Attackable;
    for Room := 1 to 8 do
      if Selected[Room] then
        if RiftOccupancyPointInRoom(Room, X, Y, Z) then
        begin
          if (NpcID = RiftRooms[Room].NpcID) and not Pet then
            GuardianSeen[Room] := True
          else if Occupant then Busy[Room] := True;
        end;
  end;
  if not RiftOccupancySnapshotActive(S, T, U, Actor, CurrentRoom, Players, Npcs) then Exit;
  Result := 0;
  for Room := 1 to 8 do
    if Selected[Room] and GuardianSeen[Room] and not Busy[Room] then
    begin Result := Room; Exit; end;
end;


function RiftDialogHasAction(Html, Action: string): Boolean;
begin
  Result := (Pos(Action + '"', Html) > 0) or (Pos(Action + '''', Html) > 0);
end;

function RiftSelectRoomGuardian(NpcID: Cardinal; var C: TRiftDialogContext): Boolean;
var TargetStarted: Cardinal;
begin
  Result := False;
  C.SessionSerial := RSessionSerial; C.TeleportSerial := RTeleportSerial;
  C.UserTeleport := 0; C.TargetOID := 0;
  if not RiftOnline then Exit;
  C.UserTeleport := User.TeleportTime;
  if not RiftRoomDialogActive(C) then Exit;
  RDiagStage := 'room-dialog.target';
  // Keep a correct target already selected by the player or a previous action.
  C.TargetOID := RiftTargetNpcOID(NpcID);
  if C.TargetOID = 0 then
  begin
    Engine.SetTargetID(NpcID);
    TargetStarted := GetTickCount;
    repeat
      if not Delay(500) then Exit;
      if not RiftRoomDialogActive(C) then Exit;
      C.TargetOID := RiftTargetNpcOID(NpcID);
    until (C.TargetOID <> 0) or (RiftElapsed(TargetStarted) >= RIFT_NPC_TARGET_WAIT_MS);
  end;
  if C.TargetOID = 0 then
  begin RiftLog('Room guardian target unavailable: ' + RTargetCheck); Exit; end;
  if not RiftRoomDialogActive(C) then Exit;
  Result := True;
end;

// Copy the verified live NPC position once; retain no object across movement/delay.
function RiftTargetNpcPoint(NpcID, TargetOID: Cardinal; var P: TRiftPoint): Boolean;
var Target: TL2Live;
begin
  Result := False;
  Target := User.Target;
  if Target = nil then Exit;
  if not Target.Valid then Exit;
  if Target.L2Class <> lcNpc then Exit;
  if Target.ID <> NpcID then Exit;
  if (TargetOID = 0) or (Target.OID <> TargetOID) then Exit;
  RiftSetPoint(P, Target.X, Target.Y, Target.Z);
  if (P.X = 0) and (P.Y = 0) then Exit;
  Result := True;
end;

function RiftOpenRoomDialog(NpcID: Cardinal; var C: TRiftDialogContext; var Html: string): Boolean;
var BeforeStamp: Cardinal; BeforeHtml: string;
begin
  Result := False;
  Html := '';
  if not RiftSelectRoomGuardian(NpcID, C) then Exit;
  BeforeStamp := Engine.DlgTime; BeforeHtml := Engine.DlgText;
  RDiagStage := 'room-dialog.open';
  Engine.DlgOpen(5000);
  if not RiftRoomDialogActive(C) then
  begin RiftLog('Room dialog interrupted by session, teleport, leader or target change'); Exit; end;
  Html := Engine.DlgText;
  if (Html = '') or ((Engine.DlgTime = BeforeStamp) and (Html = BeforeHtml)) then
  begin RiftLog('Room guardian did not return a new dialog'); Exit; end;
  Result := True;
end;

function RiftSkipDialog(NpcID: Cardinal): Boolean;
var C: TRiftDialogContext; Html, Command: string;
begin
  Result := False;
  RSkipPostponed := False;
  if RSkipUsed then
  begin RiftLog('Room change already used; no second request'); Exit; end;
  if RPendingAction <> raNone then Exit;
  if not RiftOpenRoomDialog(NpcID, C, Html) then Exit;
  Command := 'menu_select?ask=-1000&reply=2';
  if not RiftDialogHasAction(Html, 'bypass -h ' + Command) then
  begin RiftLog('Use the chance card is not offered in the current dialog'); Exit; end;
  if not RiftRoomDialogActive(C) then Exit;
  // A room can become occupied during the dialog. RB keeps its immediate skip.
  // With the waiting mode disabled, intentionally spend the card immediately.
  if FarmBadRoomsWhileWaiting and (RRoom >= 1) and (RRoom <= 8) then
  begin
    RSkipPostponed := RiftFindFreeGoodRoom <= 0;
    if not RiftRoomDialogActive(C) then Exit;
    if RSkipPostponed then
    begin RiftLog('Chance card postponed: no selected room confirmed free.'); Exit; end;
  end;
  // Reserve before sending, even if the API reply is lost or a TP is immediate.
  RSkipUsed := True;
  RPendingAction := raSkip;
  RDiagStage := 'room-dialog.change';
  Result := Engine.BypassToServer(Command);
  if Result then RiftLog('Use the chance card: request sent, NPC=' + IntToStr(NpcID))
  else RiftLog('Room change request unconfirmed; wait for teleport without retry');
end;

function RiftLeaveDialog(NpcID: Cardinal): Boolean;
var C: TRiftDialogContext; Html, BeforeHtml, Command: string; BeforeStamp: Cardinal;
begin
  Result := False;
  if RPendingAction <> raNone then Exit;
  if not RiftOpenRoomDialog(NpcID, C, Html) then Exit;
  if not RiftDialogHasAction(Html, 'link tel_dungeon_npc_giveup.htm') then
  begin RiftLog('I give up link is not offered in the current dialog'); Exit; end;
  if not RiftRoomDialogActive(C) then Exit;
  BeforeStamp := Engine.DlgTime; BeforeHtml := Html;
  RDiagStage := 'room-dialog.give-up-page';
  Engine.DlgSel('I give up.', 5000);
  if not RiftRoomDialogActive(C) then
  begin RiftLog('Leave dialog interrupted before confirmation'); Exit; end;
  Html := Engine.DlgText;
  if (Html = '') or ((Engine.DlgTime = BeforeStamp) and (Html = BeforeHtml)) then
  begin RiftLog('I give up confirmation page was not received'); Exit; end;
  Command := 'menu_select?ask=-1000&reply=1';
  if not RiftDialogHasAction(Html, 'bypass -h ' + Command) then
  begin RiftLog('Leave confirmation is not offered in the current dialog'); Exit; end;
  if not RiftRoomDialogActive(C) then Exit;
  RPendingAction := raLeave;
  RDiagStage := 'room-dialog.leave';
  Result := Engine.BypassToServer(Command);
  if Result then RiftLog('I give up: exit confirmation request sent, NPC=' + IntToStr(NpcID))
  else RiftLog('Leave request unconfirmed; wait for teleport without retry');
end;

procedure RiftTickParty;
begin
  if RiftElapsed(RPartyCheckTick) < RIFT_PARTY_CHECK_MS then Exit;
  RPartyCheckTick := GetTickCount;
  if not RiftPartyNearby then
  begin RiftLogPartyWait(RPartyWaitReason); Exit; end;
  if not RiftLeader then
  begin
    RiftLogPartyWait('Both near NPC; waiting for leader ' + Party.Leader.Name + ' to enter');
    Exit;
  end;
  RiftLog('Both characters within ' + IntToStr(RIFT_PARTY_RADIUS) + ' of entry NPC; calling entry dialog');
  RiftCancelMotion;
  RiftAttemptEntry;
end;

// Decimal conversion without this runtime's potentially narrowing IntToStr(Int64).
function RiftInventoryAmountText(Value: Int64): string;
var Digit: Integer; Negative: Boolean;
begin
  Negative := Value < 0;
  Result := '';
  repeat
    Digit := Value mod 10;
    if Digit < 0 then Digit := -Digit;
    Result := IntToStr(Digit) + Result;
    Value := Value div 10;
  until Value = 0;
  if Negative then Result := '-' + Result;
end;

function RiftBuySupplies: Boolean;
begin
  Result := False;
  if not RiftSupplySettingsValid(not RSupplySettingsLogged) then Exit;
  RSupplySettingsLogged := True;
  Result := ConsumablesCheckList(SupplyList);
  // True means the affordable plan finished, not that all maxima were reached.
  // Never call ConsumablesClearError automatically after False.
end;

function RiftReadEntryItems(var Amount: Int64): Boolean;
var Inv: TInventory; Item: TL2Item;
  I, J, UserCount, QuestCount, SeenCount: Integer;
  ItemOID: Cardinal; StackAmount: Int64; Duplicate: Boolean;
  SeenOIDs: array of Cardinal;
begin
  Result := False;
  Amount := 0;
  Inv := Engine.GetInventory;
  if Inv = nil then Exit;
  UserCount := Inv.User.Count; QuestCount := Inv.Quest.Count;
  if (UserCount < 0) or (QuestCount < 0) or (UserCount > 4096) or (QuestCount > 4096) then Exit;
  SetLength(SeenOIDs, UserCount + QuestCount);
  SeenCount := 0;
  for I := 0 to UserCount + QuestCount - 1 do
  begin
    if I < UserCount then Item := Inv.User.Items(I)
    else Item := Inv.Quest.Items(I - UserCount);
    if Item = nil then Exit;
    if not Item.Valid then Exit;
    if Item.ID <> RIFT_ENTRY_ITEM_ID then Continue;
    ItemOID := Item.OID;
    if ItemOID = 0 then Exit;
    // Compare saved numbers, never re-read inventory objects in a nested loop.
    Duplicate := False;
    for J := 0 to SeenCount - 1 do
      if SeenOIDs[J] = ItemOID then begin Duplicate := True; Break; end;
    if Duplicate then Continue;
    StackAmount := Item.Count;
    if (StackAmount < 0) or (StackAmount > 1000000000000000) then Exit;
    if Amount > 1000000000000000 - StackAmount then Exit;
    SeenOIDs[SeenCount] := ItemOID; Inc(SeenCount);
    Amount := Amount + StackAmount;
  end;
  Result := True;
end;

procedure RiftEntryItemAlert(Reason: string);
begin
  // Stop first. Notification failure must never permit the route or NPC request.
  RiftStop(Reason);
  try
    Engine.Msg('RIFT: entry blocked', Reason, $0000FF);
  except
    RiftLog('Could not display entry-item notification; see STOP above');
  end;
  try
    // Existing Windows alert sound; no sound/profile files are created.
    PlaySound('C:\Windows\Media\chord.wav', False);
  except
    RiftLog('Could not play entry-item alert sound');
  end;
  try
    Engine.BlinkWindow(True);
  except
    RiftLog('Could not blink the game window');
  end;
end;

function RiftPrepContextActive(S, T, U: Cardinal): Boolean;
begin
  Result := False;
  if RHalted or RApiFault or RPendingTeleport or RInside then Exit;
  if (RState <> rsPrepare) or not REntryArmed then Exit;
  if not RiftOnline then Exit;
  if (S <> RSessionSerial) or (T <> RTeleportSerial) then Exit;
  if (S <> RSeenSession) or (T <> RSeenTeleport) then Exit;
  if (U <> User.TeleportTime) or (U <> RSeenUserTeleport) then Exit;
  Result := True;
end;

function RiftCheckEntryItems: Boolean;
var Amount: Int64; ReadOK: Boolean; S, T, U: Cardinal;
begin
  Result := False;
  if not RiftOnline then Exit;
  S := RSessionSerial; T := RTeleportSerial; U := User.TeleportTime;
  if not RiftPrepContextActive(S, T, U) then Exit;
  RDiagStage := 'prepare.entry-items';
  ReadOK := RiftReadEntryItems(Amount);
  // A party TP may consume entry items while this read is in progress.
  if not RiftPrepContextActive(S, T, U) then Exit;
  if not ReadOK then
  begin
    RiftEntryItemAlert(User.Name + ': cannot read inventory; entry blocked');
    Exit;
  end;
  if Amount < RiftEntryItemCount then
  begin
    RiftEntryItemAlert(User.Name + ': item ' + IntToStr(RIFT_ENTRY_ITEM_ID) +
      ' have=' + RiftInventoryAmountText(Amount) + '; need=' + IntToStr(RiftEntryItemCount) +
      ' for rift ' + IntToStr(RiftLevel) + '. Add items and restart outside the rift');
    Exit;
  end;
  RiftLog('Entry items: ' + User.Name + '; ID=' + IntToStr(RIFT_ENTRY_ITEM_ID) +
    '; have=' + RiftInventoryAmountText(Amount) + '; need=' + IntToStr(RiftEntryItemCount));
  Result := True;
end;

procedure RiftBeginPrepare;
begin
  RiftCombatPause;
  RCombatWaitExpired := False;
  RPrep := rpWaitCombat;
  // Called only from the known lobby/exit cycle. Another party member can
  // enter while this character is still buffing or buying near the NPC.
  REntryArmed := True; RiftResetPartyWait;
  RPrepTick := GetTickCount;
  RiftSetState(rsPrepare, 'Prepare: buff book and supplies');
end;

procedure RiftBeginMove(P: TRiftPoint; KeepTarget: Boolean);
begin
  if not KeepTarget then Engine.CancelTarget;
  RMoveTarget := P;
  RMoveTick := GetTickCount;
  RLastMoveTick := GetTickCount - RIFT_MOVE_RETRY_MS;
  RMoveActive := True;
end;

function RiftTickMove: Integer;
begin
  Result := 0; // 0 pending, 1 arrived, -1 failed
  if not RMoveActive then begin Result := -1; Exit; end;
  if RiftNear(User.X, User.Y, User.Z, RMoveTarget, RIFT_POINT_RADIUS, 150) then
  begin RMoveActive := False; Result := 1; Exit; end;
  if RiftElapsed(RMoveTick) >= RIFT_MOVE_TIMEOUT_MS then
  begin RMoveActive := False; Result := -1; Exit; end;
  if RiftElapsed(RLastMoveTick) >= RIFT_MOVE_RETRY_MS then
  begin
    // Nonblocking API. Fix this target once, instead of randomizing each tick.
    Engine.DMoveTo(RMoveTarget.X, RMoveTarget.Y, RMoveTarget.Z);
    RLastMoveTick := GetTickCount;
  end;
end;

procedure RiftBeginRoute;
var I, RouteCandidate, StartAt, BestRoute, BestPoint: Integer; D, Best: Double;
begin
  RiftCombatPause;
  if RiftNear(User.X, User.Y, User.Z, RiftEntry, RIFT_PARTY_RADIUS, 150) then
  begin
    RiftSetState(rsParty, 'At entry NPC; waiting for both characters');
    Exit;
  end;
  RRouteIndex := Random(4); StartAt := 0;
  // Starting at an intermediate route point: resume nearest forward segment.
  // At TP/exit choose a full random route.
  if not RiftNear(User.X, User.Y, User.Z, RiftLobbyTeleport, 350, 150) and
     not RiftNear(User.X, User.Y, User.Z, RiftExits[0], 350, 150) and
     not RiftNear(User.X, User.Y, User.Z, RiftExits[1], 350, 150) then
  begin
    Best := 1000000000; BestRoute := 0; BestPoint := 0;
    for RouteCandidate := 0 to 3 do
      for I := 0 to RiftRoutes[RouteCandidate].Count - 1 do
      begin
        D := RiftPointDistanceXY(User.X, User.Y, RiftRoutes[RouteCandidate].Points[I]);
        if D < Best then begin Best := D; BestRoute := RouteCandidate; BestPoint := I; end;
      end;
    RRouteIndex := BestRoute; StartAt := BestPoint;
  end;
  RRouteCount := 0;
  for I := StartAt to RiftRoutes[RRouteIndex].Count - 1 do
  begin
    RRoutePoints[RRouteCount] := RiftRoutes[RRouteIndex].Points[I];
    // Keep the waypoint before the final NPC point exact to avoid the wall.
    if I < RiftRoutes[RRouteIndex].Count - 1 then
    begin
      RRoutePoints[RRouteCount].X := RRoutePoints[RRouteCount].X + Random(2 * RIFT_ROUTE_JITTER + 1) - RIFT_ROUTE_JITTER;
      RRoutePoints[RRouteCount].Y := RRoutePoints[RRouteCount].Y + Random(2 * RIFT_ROUTE_JITTER + 1) - RIFT_ROUTE_JITTER;
    end;
    Inc(RRouteCount);
  end;
  // Exact final approach: jitter cannot leave the party outside NPC radius.
  RRoutePoints[RRouteCount] := RiftEntry; Inc(RRouteCount);
  RRoutePoint := 0;
  RiftBeginMove(RRoutePoints[0], False);
  RiftSetState(rsRoute, 'Route ' + IntToStr(RRouteIndex + 1));
end;

procedure RiftTickPrepare;
var BuyOK, CommandOK: Boolean; SessionBefore, TeleportBefore, UserTeleportBefore: Cardinal;
begin
  if not RiftOnline then Exit;
  SessionBefore := RSessionSerial;
  TeleportBefore := RTeleportSerial;
  UserTeleportBefore := User.TeleportTime;
  if not RiftPrepContextActive(SessionBefore, TeleportBefore, UserTeleportBefore) then Exit;
  // Wait for combat to end at the lobby. If the flag stays set for two minutes
  // during this initial wait, treat it as stale and keep the preparation routine running.
  if User.InCombat and not RCombatWaitExpired then
  begin
    if (RPrep <> rpWaitCombat) or
       (RiftElapsed(RPrepTick) < RIFT_COMBAT_WAIT_TIMEOUT_MS) then Exit;
    RCombatWaitExpired := True;
    RiftLog('Combat flag remained set for 120 seconds at lobby; treating it as stale and resuming preparation');
  end;
  case RPrep of
    rpWaitCombat: begin RPrep := rpBuffOpen; RPrepTick := GetTickCount; end;
    rpBuffOpen:
      begin
        CommandOK := Engine.BypassToServer('_bbs_buffer_show');
        if not RiftPrepContextActive(SessionBefore, TeleportBefore, UserTeleportBefore) then Exit;
        if CommandOK then
        begin RPrep := rpBuffApply; RPrepTick := GetTickCount; end
        else RiftStop('Could not open the buff page');
      end;
    rpBuffApply:
      if RiftElapsed(RPrepTick) >= 555 then
      begin
        CommandOK := Engine.BypassToServer('book_use?name=' + BuffBook + '&pre=0&target=Player');
        if not RiftPrepContextActive(SessionBefore, TeleportBefore, UserTeleportBefore) then Exit;
        if CommandOK then
        begin RPrep := rpBuffWait; RPrepTick := GetTickCount; end
        else RiftStop('Could not send the buff preset request');
      end;
    rpBuffWait:
      // Apply the preset every preparation cycle; do not inspect existing buffs.
      if RiftElapsed(RPrepTick) >= 2000 then
        RPrep := rpSupplies;
    rpSupplies:
      begin
        BuyOK := RiftBuySupplies;
        // The procurement module is synchronous and can yield during purchases.
        // Let TickSession/teleport handling process events before advancing.
        if not RiftPrepContextActive(SessionBefore, TeleportBefore, UserTeleportBefore) then Exit;
        if not BuyOK then
        begin
          RiftStop('Supplies failed; see SUPPLIES log. No retry or further inventory scan');
          Exit;
        end;
        RPrep := rpComplete;
      end;
    rpComplete:
      begin
        // Both characters run this after buff/buy, on startup and every re-entry.
        if not RiftCheckEntryItems then Exit;
        if not RiftPrepContextActive(SessionBefore, TeleportBefore, UserTeleportBefore) then Exit;
        RiftBeginRoute;
      end;
  end;
end;

function RiftRoomNPC: Cardinal;
begin
  if RRoom = 9 then Result := RiftBossNpcID
  else Result := RiftRooms[RRoom].NpcID;
end;

procedure RiftStartFarm;
var S, T, U: Cardinal; MapOK: Boolean;
begin
  // A lifecycle change can interrupt map loading; never call that active farming.
  RState := rsStartFarm;
  if not RiftOnline then Exit;
  S := RSessionSerial; T := RTeleportSerial; U := User.TeleportTime;
  if (S <> RSeenSession) or (T <> RSeenTeleport) or (U <> RSeenUserTeleport) then Exit;
  RDiagStage := 'farm.pause';
  RiftCombatTransit;
  if not RiftOnline then Exit;
  if (S <> RSessionSerial) or (T <> RTeleportSerial) or (U <> User.TeleportTime) then Exit;
  RDiagStage := 'farm.load-map';
  MapOK := Engine.LoadZone(MapDirectory + RiftRooms[RRoom].MapName);
  if (S <> RSessionSerial) or (T <> RTeleportSerial) or not RiftOnline then
  begin Exit; end;
  if U <> User.TeleportTime then Exit;
  if not MapOK then
  begin RiftStop('LoadZone failed: ' + MapDirectory + RiftRooms[RRoom].MapName); Exit; end;
  RiftCombatBindRoom(RRoom);
  RDiagStage := 'farm.resume';
  RiftCombatResume;
  if not RiftOnline then Exit;
  if (S <> RSessionSerial) or (T <> RTeleportSerial) or (U <> User.TeleportTime) then Exit;
  RiftSetState(rsFarm, 'Farm room ' + IntToStr(RRoom) + '; map=' + RiftRooms[RRoom].MapName);
end;

procedure RiftWaitForGoodRoom;
begin
  if RHalted or RApiFault or RPendingTeleport then Exit;
  if not FarmBadRoomsWhileWaiting then Exit;
  if (RRoom < 1) or (RRoom > 8) then Exit;
  RWaitingGoodRoom := True;
  RSkipPostponed := False;
  RGoodRoomCheckTick := GetTickCount;
  RCFinishFight := False;
  RAction := raNone;
  if RState = rsFarm then Exit;
  RiftLog('Farm current room ' + IntToStr(RRoom) + ' while waiting for a free selected room.');
  RiftCancelMotion;
  RiftStartFarm;
end;

procedure RiftBeginGuardian;
var P: TRiftPoint; C: TRiftDialogContext; Located: Boolean;
    S, T, U: Cardinal; FreeRoom: Integer;
begin
  if RHalted or RApiFault or RPendingTeleport then Exit;
  if not RiftOnline then Exit;
  S := RSessionSerial; T := RTeleportSerial; U := User.TeleportTime;
  if (S <> RSeenSession) or (T <> RSeenTeleport) or (U <> RSeenUserTeleport) then Exit;
  if FarmBadRoomsWhileWaiting and (RRoom >= 1) and (RRoom <= 8) and not RSkipUsed then
  begin
    // Only the leader decides when to use the card; the follower keeps Assist.
    if not RRunLeaderHere then begin RiftWaitForGoodRoom; Exit; end;
    FreeRoom := RiftFindFreeGoodRoom;
    if RHalted or RApiFault or RPendingTeleport then Exit;
    if not RiftOnline then Exit;
    if RPendingTeleport or (S <> RSessionSerial) or (T <> RTeleportSerial) or
      (U <> User.TeleportTime) then Exit;
    if FreeRoom <= 0 then begin RiftWaitForGoodRoom; Exit; end;
  end;
  RWaitingGoodRoom := False;
  RCFinishFight := False;
  // Normal bad rooms and RB rooms share the one-skip-per-run allowance.
  if RSkipUsed then RAction := raLeave
  else RAction := raSkip;
  RiftCombatTransit;
  Engine.ClearZone;
  if not RiftLeader then
  begin RiftSetState(rsWaitTeleport, 'Follower: wait for leader room action'); Exit; end;
  if RiftRooms[RRoom].HasCoordinates then
  begin
    P := RiftRooms[RRoom].Guardian;
    RiftCancelMotion;
    if (RRoom = 9) and (RiftLevel = 60) then
      RiftLog('RB60: approach recorded guardian point; NPC 31900');
  end
  else
  begin
    // Stop the old path while preserving an already selected correct guardian.
    RMoveActive := False;
    Engine.DMoveTo(User.X, User.Y, User.Z);
    Located := RiftSelectRoomGuardian(RiftRoomNPC, C);
    if Located then Located := RiftTargetNpcPoint(RiftRoomNPC, C.TargetOID, P);
    if not Located then
    begin
      C.TargetOID := 0;
      if RiftRoomDialogActive(C) then
        RiftStop('Cannot locate the live RB guardian; no movement to unverified coordinates');
      Exit;
    end;
    if not RiftRoomDialogActive(C) then Exit;
    if RRoom = 9 then RiftLog('RB: use live guardian position')
    else RiftLog('Room ' + IntToStr(RRoom) + ': use live guardian position');
  end;
  RiftBeginMove(P, True);
  RiftSetState(rsGuardian, 'Approach room guardian');
end;

procedure RiftTickRoomAvailability;
var FreeRoom: Integer;
begin
  if not FarmBadRoomsWhileWaiting then Exit;
  if not RWaitingGoodRoom or not RRunLeaderHere or RSkipUsed then Exit;
  if (RRoom < 1) or (RRoom > 8) then Exit;
  if not RCContextActive then Exit;
  if RiftElapsed(RGoodRoomCheckTick) < RIFT_GOOD_ROOM_CHECK_MS then Exit;
  RGoodRoomCheckTick := GetTickCount;
  FreeRoom := RiftFindFreeGoodRoom;
  if not RCContextActive then Exit;
  if (FreeRoom > 0) and not RCFinishFight then
    RiftLog('Selected room ' + IntToStr(FreeRoom) + ' is free; finish current mob and Sweep before the chance card.');
  if (FreeRoom <= 0) and RCFinishFight then
    RiftLog('Selected rooms became busy; continue farming the current room.');
  RCFinishFight := FreeRoom > 0;
end;

procedure RiftTickFarm;
begin
  // Target control uses the loaded zone, without room detection or map reloads.
  if RHalted or RPendingTeleport then Exit;
  RiftTickRoomAvailability;
  RiftCombatTick;
  if RWaitingGoodRoom and RRunLeaderHere and RCFinishFight then
    if (RCFightOID = 0) and (RCPendingOID = 0) then
      if RCContextActive then
        if not RCCasting then begin RiftBeginGuardian; Exit; end;
  if (not RRoomTimerReported) and (RiftElapsed(RRoomTick) >= RIFT_ROOM_EXPECTED_MS) then
  begin
    RRoomTimerReported := True;
    RiftLog('Eight minutes elapsed; wait for server teleport, do not consume skip');
  end;
end;

procedure RiftAcceptRoom(Number: Integer);
var Leader: TL2Char;
begin
  RPendingTeleport := False;
  RWaitingGoodRoom := False; RSkipPostponed := False;
  RMoveActive := False;
  RiftCombatInvalidate;
  RiftCombatTransit;
  RiftCancelMotion;
  if not RInside then
  begin
    // Destination is already a room: a missing party must not apply lobby pause.
    RInside := True;
    if Party = nil then begin RiftStop('Party unavailable at room entry'); Exit; end;
    Leader := Party.Leader;
    if Leader = nil then begin RiftStop('Party leader unavailable'); Exit; end;
    RRunLeaderOID := Leader.OID;
    RRunLeaderName := Leader.Name;
    RRunKnown := True;
    RSkipUsed := False;
    RRoomVisits := 0;
  end;
  // Names survive relog/OID changes; changing either participant is rejected.
  RRunLeaderHere := RRunLeaderName = RActorName;
  RRunPartyCheckTick := GetTickCount - RIFT_STATUS_CHECK_MS;
  if RPendingAction = raSkip then RSkipUsed := True;
  REntryArmed := False; REntryPending := False;
  RPendingAction := raNone;
  RRoom := Number;
  Inc(RRoomVisits);
  RRoomTick := GetTickCount; RRoomTimerReported := False;
  RiftLog('Visit=' + IntToStr(RRoomVisits) + ', room=' + IntToStr(RRoom));
  if Number = 9 then
  begin
    RiftBeginGuardian;
    Exit;
  end;
  if RiftRooms[Number].Policy = 1 then begin RiftStartFarm; Exit; end;
  RiftBeginGuardian;
end;

procedure RiftAcceptExit;
begin
  RWaitingGoodRoom := False; RSkipPostponed := False;
  RiftCombatInvalidate;
  RiftCombatPause;
  Engine.ClearZone;
  RInside := False; RRunKnown := False; RSkipUsed := False;
  RAction := raNone; RPendingAction := raNone;
  RRoom := 0; RRoomVisits := 0; RMoveActive := False;
  RPendingTeleport := False;
  REntryArmed := False; REntryPending := False;
  RiftResetPartyWait; RiftCancelMotion;
  RExitDelay := 2000 + Random(8001);
  RiftSetState(rsExitDelay, 'Exit confirmed; randomized 2-10 second pause');
end;

// Used once after a callback, only if no known room/lobby matched first.
// The supplied farm maps extend beyond the approximate recorded corners.
function RiftNearCurrentFarmEdge(X, Y, Z: Integer): Boolean;
var I, J: Integer;
begin
  Result := False;
  if not RInside or not RRunKnown then Exit;
  if (RState <> rsFarm) and (RState <> rsStartFarm) then Exit;
  if (RRoom < 1) or (RRoom > 8) then Exit;
  if not RiftRooms[RRoom].HasBounds then Exit;
  J := 3;
  for I := 0 to 3 do
  begin
    if RiftNearSegment(X, Y, Z, RiftRooms[RRoom].Corners[J],
      RiftRooms[RRoom].Corners[I], RIFT_CURRENT_ROOM_EDGE_MARGIN, 150) then
    begin Result := True; Exit; end;
    J := I;
  end;
end;

procedure RiftResolveTeleport;
var X, Y, Z, Room: Integer;
begin
  if RiftElapsed(RTeleportTick) > 30000 then
  begin RiftStop('Teleport destination unconfirmed; no repeated NPC request'); Exit; end;
  if RiftElapsed(RTeleportTick) < RIFT_TELEPORT_SETTLE_MS then Exit;
  X := User.X; Y := User.Y; Z := User.Z;
  if (X = 0) and (Y = 0) then Exit;
  // Classify once for this callback batch. No room polling while farming.
  RPendingTeleport := False;
  if RiftIsLobby(X, Y, Z) then
  begin
    if RInside then RiftAcceptExit;
    Exit;
  end;
  Room := RiftDetectSpawnRoom(X, Y, Z);
  if Room = 0 then Room := RiftContainingRoom(X, Y, Z);
  if Room = 0 then
    if RiftNearCurrentFarmEdge(X, Y, Z) then Room := RRoom;
  if Room = 0 then
  begin
    if not RInside and not REntryArmed then
    begin RiftStop('Unknown teleport outside a rift entry/run'); Exit; end;
    Room := 9;
  end;
  if not RInside and not REntryArmed then
  begin RiftStop('Room reached outside an armed entry'); Exit; end;
  if RInside and (Room = RRoom) then
  begin
    // A repeated same-room callback confirms neither a skip nor a leave.
    if RPendingAction <> raNone then Exit;
    if RState = rsStartFarm then RiftStartFarm;
    Exit;
  end;
  if RPendingAction = raLeave then
  begin RiftStop('Leave request led to another room, not lobby'); Exit; end;
  RiftAcceptRoom(Room);
end;

procedure RiftTickSession;
var SessionNow, ActorNow: Cardinal; Changed: Boolean; ActorNameNow: string;
begin
  RDiagStage := 'session.online';
  ROnline := RiftOnline;
  SessionNow := RSessionSerial;
  if not ROnline then
  begin
    if RWasOnline then
    begin
      RExpDone := False; RMoveActive := False;
      RiftSetState(rsOffline, 'Offline; waiting for game entry');
    end;
    RWasOnline := False;
    RSeenSession := SessionNow;
    Exit;
  end;
  ActorNow := User.OID;
  Changed := not RWasOnline or (SessionNow <> RSeenSession);
  if RHasActor then Changed := Changed or (RActor <> ActorNow);
  // Session callbacks/OID are immediate; the name is only a slow fallback.
  if not Changed and RHasActor then
    if RiftElapsed(RIdentityCheckTick) >= RIFT_STATUS_CHECK_MS then
    begin
      RIdentityCheckTick := GetTickCount;
      Changed := RActorName <> User.Name;
    end;
  if Changed then
  begin
    RDiagStage := 'session.character';
    ActorNameNow := User.Name;
    if RHasActor and (RActorName <> ActorNameNow) then
    begin
      RInside := False; RRunKnown := False; RSkipUsed := False;
      RPendingAction := raNone; REntryArmed := False;
      RPendingTeleport := False;
      RHalted := True;
      RiftLog('Character changed: restart with its own settings');
      RiftSetState(rsStopped, 'Controller stopped; inspect log');
      Exit;
    end;
    RActor := ActorNow; RActorName := ActorNameNow; RHasActor := True;
    RIdentityCheckTick := GetTickCount;
    RRunPartyCheckTick := GetTickCount - RIFT_STATUS_CHECK_MS;
    RSessionTick := GetTickCount; RExpDone := False;
    RMoveActive := False;
    RSeenTeleport := RTeleportSerial; RPendingTeleport := False;
    RDiagStage := 'session.teleport-time';
    RSeenUserTeleport := User.TeleportTime;
    // Establish the known lobby origin before the login/EXP delay too.
    // This does not permit a fresh controller started inside a room.
    if not RInside and not REntryPending then
      REntryArmed := RiftIsLobby(User.X, User.Y, User.Z);
    RiftResetPartyWait;
    if not RCombatReady then
    begin
      RDiagStage := 'session.modules-init';
      RCombatReady := RiftCombatInit;
      if not RCombatReady then begin RiftFatal; Exit; end;
    end;
    if RCombatReady then
    begin
      RDiagStage := 'session.modules-pause';
      RiftCombatInvalidate;
      if RInside then RiftCombatTransit else RiftCombatPause;
    end;
    RDiagStage := 'session.cancel-motion';
    RiftCancelMotion;
    if RHalted then RiftSetState(rsStopped, 'Controller stopped; inspect log')
    else RiftSetState(rsLocate, 'Game entry detected; schedule EXP OFF');
  end;
  RSeenSession := SessionNow; RWasOnline := True;
end;

procedure RiftTickExpOff;
begin
  if RExpDone then Exit;
  if RiftElapsed(RSessionTick) < RIFT_LOGIN_DELAY_MS then Exit;
  if Engine.BypassToServer('exp?state=off') then
  begin RExpDone := True; RiftLog('EXP OFF command sent'); end
  else RSessionTick := GetTickCount;
end;

procedure RiftTickLocate;
var Room: Integer;
begin
  if REntryPending then
  begin RiftStop('Relog with unconfirmed entry request; do not repeat it'); Exit; end;
  if RiftIsLobby(User.X, User.Y, User.Z) then
  begin
    if RInside then begin RiftAcceptExit; Exit; end;
    RiftBeginPrepare;
    Exit;
  end;
  Room := RiftDetectSpawnRoom(User.X, User.Y, User.Z);
  if Room = 0 then Room := RiftContainingRoom(User.X, User.Y, User.Z);
  if (Room > 0) and RInside and RRunKnown then
  begin
    // Relog of this running controller preserves the skip allowance.
    if Room = RRoom then
    begin
      if RPendingAction <> raNone then
      begin RiftStop('Relog with unconfirmed NPC request; do not repeat it'); Exit; end;
      if Room = 9 then
      begin
        RiftBeginGuardian;
      end
      else if RiftRooms[Room].Policy = 1 then RiftStartFarm else RiftBeginGuardian;
    end
    else
    begin
      // A reconnect alone does not establish which transition happened offline.
      RiftStop('Room changed while offline; run history cannot be confirmed');
    end;
    Exit;
  end;
  if (Room = 0) and RInside and RRunKnown and (RRoom = 9) then
  begin
    if RPendingAction <> raNone then
    begin RiftStop('Relog in RB with unconfirmed NPC request'); Exit; end;
    RiftBeginGuardian;
    Exit;
  end;
  RiftStop('Start at lobby TP, entry NPC or exit; inside history is unknown');
end;

procedure RiftTickRoomDialog;
var Sent: Boolean; S, T, U: Cardinal;
begin
  if RHalted or RApiFault or RPendingTeleport then Exit;
  if not RiftOnline then Exit;
  if not RiftLeader then
  begin RiftSetState(rsWaitTeleport, 'Follower waits for room action'); Exit; end;
  Sent := False;
  S := RSessionSerial; T := RTeleportSerial; U := User.TeleportTime;
  if (S <> RSeenSession) or (T <> RSeenTeleport) or (U <> RSeenUserTeleport) then Exit;
  // Stop movement without cancelling an already selected room guardian.
  RMoveActive := False;
  Engine.DMoveTo(User.X, User.Y, User.Z);
  if RHalted or RApiFault or RPendingTeleport then Exit;
  if not RiftOnline then Exit;
  if (S <> RSessionSerial) or (T <> RTeleportSerial) or (U <> User.TeleportTime) then Exit;
  if RAction = raSkip then Sent := RiftSkipDialog(RiftRoomNPC)
  else if RAction = raLeave then Sent := RiftLeaveDialog(RiftRoomNPC);
  // A server TP/relog during the dialog belongs to the main lifecycle handler.
  if RHalted or RApiFault or RPendingTeleport then Exit;
  if not RiftOnline then Exit;
  if (S <> RSessionSerial) or (T <> RTeleportSerial) or (U <> User.TeleportTime) then Exit;
  if not Sent then
  begin
    if FarmBadRoomsWhileWaiting and RSkipPostponed and (RPendingAction = raNone) then
    begin RiftWaitForGoodRoom; Exit; end;
    if RPendingAction <> raNone then
      RiftSetState(rsWaitTeleport, 'Room request unconfirmed; wait for teleport, no retry')
    else RiftStop('Room dialog failed before final request; inspect the preceding log');
    Exit;
  end;
  RiftSetState(rsWaitTeleport, 'NPC request sent; await actual teleport');
end;

procedure RiftTick;
var MoveResult: Integer; TeleportNow, UserTeleportNow: Cardinal; Leader: TL2Char;
begin
  // A stopped controller must not keep touching a possibly broken API.
  if RHalted then Exit;
  RiftTickSession;
  if RHalted then Exit;
  if RApiFault then Exit;
  RDiagStage := 'tick.weapon';
  RiftWeaponTick;
  if not ROnline then Exit;
  RDiagStage := 'tick.exp-off';
  RiftTickExpOff;
  if not RExpDone then Exit;
  if RState = rsStopped then Exit;
  RDiagStage := 'tick.teleport';
  TeleportNow := RTeleportSerial;
  UserTeleportNow := User.TeleportTime;
  // TeleportTime remains a guard for commands, not a separate room-change event.
  RSeenUserTeleport := UserTeleportNow;
  if TeleportNow <> RSeenTeleport then
  begin
    RSeenTeleport := TeleportNow;
    if not RPendingTeleport then
    begin
      RPendingTeleport := True;
      RTeleportTick := GetTickCount;
    end;
  end;
  if RPendingTeleport then
  begin
    if User.Dead then
    begin RiftStop('Character is dead; resurrection policy is not configured'); Exit; end;
    RiftResolveTeleport;
    Exit;
  end;
  // Party objects can be absent while loading a room. Check after TP settles.
  RDiagStage := 'tick.character-party';
  if User.Dead then
  begin RiftStop('Character is dead; resurrection policy is not configured'); Exit; end;
  // Finish the first complete equipment snapshot before starting gameplay.
  // Session and teleport handling above still run while inventory loads.
  if not RiftWeaponRemembered then Exit;
  if RInside then
    if RiftElapsed(RRunPartyCheckTick) >= RIFT_STATUS_CHECK_MS then
    begin
      RRunPartyCheckTick := GetTickCount;
      if Party = nil then begin RiftStop('Party lost during run'); Exit; end;
      Leader := Party.Leader;
      if Leader = nil then begin RiftStop('Party leader lost during run'); Exit; end;
      if Leader.Name <> RRunLeaderName then
      begin RiftStop('Leader changed; skip allowance cannot be transferred implicitly'); Exit; end;
      RRunLeaderOID := Leader.OID;
      RRunLeaderHere := Leader.OID = RActor;
    end;
  RDiagStage := 'tick.state-' + IntToStr(Ord(RState));
  case RState of
    rsLocate: RiftTickLocate;
    rsPrepare: RiftTickPrepare;
    rsRoute:
      begin
        MoveResult := RiftTickMove;
        if MoveResult < 0 then RiftStop('Route point timeout; no blind continuation');
        if MoveResult = 1 then
        begin
          Inc(RRoutePoint);
          if RRoutePoint < RRouteCount then RiftBeginMove(RRoutePoints[RRoutePoint], False)
          else
          begin RiftResetPartyWait;
            RiftSetState(rsParty, 'Route finished; wait for party'); end;
        end;
      end;
    rsParty: RiftTickParty;
    rsWaitTeleport:
      begin
        if REntryPending then RiftTickEntryRetry
        else if RRunLeaderHere and (RiftElapsed(RStateTick) > 30000) then
          RiftStop('No teleport after NPC request; inspect manually');
      end;
    rsStartFarm: RiftStartFarm;
    rsFarm: RiftTickFarm;
    rsGuardian:
      begin
        MoveResult := RiftTickMove;
        if MoveResult < 0 then RiftStop('Guardian approach timed out');
        if MoveResult = 1 then RiftSetState(rsRoomDialog, 'At guardian');
      end;
    rsRoomDialog: RiftTickRoomDialog;
    rsExitDelay:
      if RiftElapsed(RStateTick) >= RExitDelay then RiftBeginPrepare;
  end;
end;

procedure RiftRun(const Config: TRiftConfig);
begin
  FarmRiftLevel := Config.FarmRiftLevel;
  MaxMobHP := Config.MaxMobHP;
  GoodRooms := Config.GoodRooms;
  FarmBadRoomsWhileWaiting := Config.FarmBadRoomsWhileWaiting;
  BuffBook := Config.BuffBook;
  MapDirectory := Config.MapDirectory;
  SupplyList := Config.SupplyList;
  RApiFault := False; RDiagStage := 'startup.configure';
  RiftLog('START ' + RIFT_BUILD_ID + '; current combat profile');
  RiftLog('Party leader: scripted targets. Follower: configure native Assist on the leader in the current profile.');
  RiftLog('Leader target filter: loaded-zone NPCs only; maximum HP <= ' + IntToStr(MaxMobHP) + '.');
  RiftWeaponInit;
  Randomize;
  if not RiftConfigure then
  begin RiftLog('Cannot configure the selected rift dataset'); Exit; end;
  RDiagStage := 'startup.settings';
  if not RiftSettingsValid then Exit;
  RState := rsOffline;
  REventsEnabled := True;
  RiftLog('Rift controller started; native callbacks + one action loop');
  try
    while Delay(RIFT_LOOP_MS) do
      try
        RiftTick;
        if RApiFault then Break;
      except
        RiftFatal;
        Break;
      end;
  finally
    REventsEnabled := False;
    if not RApiFault then
      if RCombatReady then RiftCombatCleanup;
  end;
end;

end.
