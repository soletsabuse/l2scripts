unit PluginAPI;

interface

uses Windows, Classes;

const
  TARGET_TIME = 2000;

type
  TL2Status = (lsOff, lsOffline, lsOnline);
  TScriptStatus = (ssStopped, ssCompile, ssRunning, ssPause, ssTerminate);
  TL2Race   = (rtHuman, rtElf, rtDarkElf, rtOrc, rtDwarf, rtKamael, rtErthea, rtUnknown);
  TL2Class  = (lcError, lcDrop, lcNpc, lcPet, lcChar, lcUser, lcBuff, lcSkill, lcItem);
  TLootType = (ldLooter, ldRandom, ldRandomSpoil, ldOrder);
  TStoreType= (stNone, stSell, stPrepareSell, stBuy, stPrepareBuy, stManufacture, stPrepareManufacture, stObservingGames, stSellPackage);
  TL2Action = (laNull, laSpawn, laDelete, laPetSpawn, laPetDelete, laPetJoin,
               laPetLeave, laCharJoin, laInvite, laDie, laRevive, laMyRevive, laStats,
               laMyTarget, laMyUnTarget, laTarget, laUnTarget, laInGame, laBuffs, laPartyBuffs,
               laSkills, laConfirmDlg, laDlg, laSysMsg, laMoveType, laWaitType, laMyWaitType, laStart, laStop, laStartAttack,
               laStopAttack, laCast, laCancelCast, laMyCancelCast, laCastFailed, laMyCastFailed, laTeleport, laInvUpdate,
               laAutoSoulShot, laNpcTrade, laChat, laKey, laCharSelect, laLeaveParty, laPost, laLearn,
               laAll, laMyCast, laDelay, laStatus, laAuction, laAuctionSL, atCaptcha, atMail, atTaxRate, laLoginState);
  TL2Actions = set of TL2Action;
  TL2ChatType = (ctALL, ctSHOUT, ctPRIVATE, ctPARTY, ctCLAN, ctSYSTEM, ctPETITION,
                 ctCONSULTANT, ctTRADE, ctALLIANCE, ctANNOUNCEMENT, ctFERRY,
                 ctFRIEND, ctMSN, ctPARTY_ROOM, ctCOMMANDER, ctCOMMAND_CHANNEL,
                 ctHERO, ctCRITICAL_ANNOUNCEMENT, ctSCREEN_ANNOUNCEMENT, ctTERRITORY,
                 ctMULTI_PARTY, ctNPC_LOCAL, ctNPC_SHOUT);
  TRestartType = (rtTown, rtClanHall, rtCastle, rtFort, rtFlags, rtLCoin);
  TZoneType = (ztGeneral, ztPeace, ztPvP, ztSiege, ztSevenSigns, ztAlt, ztUnknown);
  TMessageType = (mtSystem, mtAll, mtPrivate, mtParty, mtClan, mtFriend, mtShout, mtScreen);
///////////////////////////////////////////////////////////////////////////////
  IL2Object = interface
  ['{7977C7BC-274B-4C3B-9256-665EC0499966}']
    function GetName: string;
    function ID: Cardinal;
    function OID: Cardinal;
    function Valid: Boolean;
    function L2Class: TL2Class;
    function GetIcoData: Pointer;
    function GetIcoHandle: THandle;
    function GetIcoBytes(mem: Pointer; size: Cardinal): Cardinal;
    function GetVar(Index: Cardinal = 0): Cardinal;                               // 2.1
    procedure SetVar(Value: Cardinal; Index: Cardinal = 0);                       // 2.1
    property Name: string read GetName;
  end;

  IL2Spawn = interface(IL2Object)
  ['{1EE9876E-E2AE-49C5-AB4E-E85434023FC1}']
    function X: Integer;
    function Y: Integer;
    function Z: Integer;
    function DistTo(X, Y, Z: Integer): Cardinal; overload;
    function DistTo(L2Spawn: IL2Spawn): Cardinal; overload;
    function InZone: Boolean;
    function InRange(X, Y, Z, Range: Integer; ZRange: Integer = 500;
      Rect: Boolean = False): Boolean;
    function InPoly(const Polygon: array of Integer): Boolean;
    function SpawnTime: Cardinal;
  end;

  IL2Drop = interface(IL2Spawn)
  ['{6787B731-0A76-4F96-84F4-D4E77C794578}']
    function Count: Int64;
    function OwnerOID: Cardinal;
    function Stackable: Boolean;
    function IsMy: Boolean;
    function L2Class: TL2Class;
  end;

  IL2List = interface;
  IL2Buff = interface;
  IBuffList = interface;

  IL2Live = interface(IL2Spawn)
  ['{BBB45971-D573-4F7E-8A62-67C3024C2FD7}']
    function CheckState(Attr: Byte): Boolean;
    function Attackable: Boolean;
    function Sweepable: Boolean;
    function Title: string;
    function Level: Byte;
    function HP: Cardinal;
    function MP: Cardinal;
    function CurHP: Cardinal;
    function MaxHP: Cardinal;
    function CurMP: Cardinal;
    function MaxMP: Cardinal;
    function Load: Cardinal;
    function EXP: Int64;
    function EXP2: Int64;
    function SP: Int64;
    function PK: Boolean;
    function PvP: Boolean;
    function Karma: Integer;
    function Running: Boolean;
    function InCombat: Boolean;
    function Sitting: Boolean;
    function Dropped: Boolean;
    function IsMember: Boolean;
    function Dead: Boolean;
    function Speed: Double;
    function Moved: Boolean;
    function Invisible: Boolean;
    function Relation: Cardinal;
    function ClanID: Cardinal;
    function AllyID: Cardinal;
    function Fly: Boolean;
    function Team: Byte;
    function GetCast: IL2Buff;
    function GetBuffs: IBuffList;
    function GetAbnormals: IBuffList;
    function AbnormalID : Cardinal;
    function GetTarget: IL2Live;
    function Clan: string;
    function Ally: string;
    function AtkOID: Cardinal;
    function AtkTime: Cardinal;
    function MyAtkTime: Cardinal;
    function TeleportTime: Cardinal;
    function TeleportDist: Cardinal;
    function Fishing: Integer;
    function Targetable: Boolean;
    function ShowName: Boolean;
    function AbnormalID2: Cardinal;
    function DeadTime: Cardinal;
    function Enchant: Byte;
    function EnchantA: Byte;
    function GetEquips: IL2List;
    function ToX: Integer;
    function ToY: Integer;
    function ToZ: Integer;
    function StartX: Integer;
    function StartY: Integer;
    function StartZ: Integer;
    function CastSpd: Cardinal;
    function AtkSpd: Cardinal;
    function NameColor  : Cardinal;
    function TitleColor : Cardinal;
    function Inviseble: Boolean;
    function CurDP: Cardinal;  // DeathPoints
    function MaxDP: Cardinal;
    function RunSpd     : Cardinal;
    function WalkSpd    : Cardinal;
    function FlyRunSpd  : Cardinal;
    function FlyWalkSpd : Cardinal;
    function MultSpd    : Double;
    function MultAtk    : Double;
    function ColRadius  : Double;
    function ColHeight  : Double;
    function GetVar(Index: Cardinal = 0): Cardinal;
    procedure SetVar(Value: Cardinal; Index: Cardinal = 0);
    property Cast: IL2Buff read GetCast;
    property Buffs: IBuffList read GetBuffs;
    property Abnormals: IBuffList read GetAbnormals;
    property Target: IL2Live read GetTarget;
    property Equips: IL2List read GetEquips;
  end;

  IL2Npc = interface(IL2Live)
  ['{31E0E34F-54AC-4506-B3D5-E8C7590A90E7}']
    function IsPet: Boolean;
    function PetType: Cardinal;
    function GetOwner: IL2Live;
    function NpcType: Byte;
    function NpcCount: Cardinal;
    function L2Class: TL2Class;
    property Owner: IL2Live read GetOwner;
  end;

 IL2Pet = interface(IL2Npc)
 ['{D1C794FE-A1C1-4F41-BF85-7DB1059BF5C0}']
    function Fed: Cardinal;
    function L2Class: TL2Class;
 end;

  IL2Char = interface(IL2Live)
  ['{7AB1CFC1-7F0B-4E60-A2AC-C8C3DC1D8BED}']
    function CP       : Cardinal;
    function CurCP    : Cardinal;
    function MaxCP    : Cardinal;
    function Sex      : Cardinal;
    function Race     : Cardinal;
    function Hero     : Boolean;
    function Noble    : Boolean;
    function ClassID  : Cardinal;
    function MainClass: Cardinal;
    function MountType: Byte;
    function StoreType: Byte;
    function CubicCount: Cardinal;
    function Recom: Cardinal;
    function Premium  : Boolean;
    function LoadCrest(Data: Pointer): Boolean;
    function GetClassName: string;
    function GetClassName2: string;
    function GetClassPrior: Cardinal;
    function GetCrestIcoHandle: THandle;
    function GetClanID: Cardinal;
    function GetClanName: string;
    function GetAllyName: string;
    property ClassName: string read GetClassName;
    property ClassName2: string read GetClassName2;
    property ClassPriority: Cardinal read GetClassPrior;
    property CrestIcoHandle: THandle read GetCrestIcoHandle;
    property ClanID: Cardinal read GetClanID;
    property ClanName: string read GetClanName;
    property AllyName: string read GetAllyName;
  end;

  IL2User = interface(IL2Char)
  ['{5D7818F4-F4AB-4B08-AB1B-656F0FBF1792}']
    function CanCryst: Boolean;
    function Charges: Cardinal;
    function WeightPenalty: Cardinal;
    function WeapPenalty: Cardinal;
    function ArmorPenalty: Cardinal;
    function DeathPenalty: Cardinal;
    function Souls: Cardinal;
    function STR: Cardinal;
    function DEX: Cardinal;
    function CON: Cardinal;
    function INT: Cardinal;
    function WIT: Cardinal;
    function MEN: Cardinal;
    function PAtk: Cardinal;
    function PASpd: Cardinal;
    function PDef: Cardinal;
    function Evasion: Cardinal;
    function Accuracy: Cardinal;
    function CritHit: Cardinal;
    function MAtk: Cardinal;
    function MDef: Cardinal;
    function MAccuracy: Cardinal;
    function MEvasioon: Cardinal;
    function MCritical: Cardinal;
    function L2Class: TL2Class;
  end;

  IL2Buff = interface(IL2Object)
  ['{8FDDB8CA-DE2A-4D00-84EA-D0F385268779}']
    function GetName: string;
    function Level: Cardinal;
    function Level2: Cardinal;
    function EndTime: Cardinal;
    function ReuseTime: Cardinal;
    function StartTime: Cardinal;
    function L2Class: TL2Class;
    property Name: string read GetName;
  end;

  IL2Skill = interface(IL2Buff)
  ['{B5960569-DE0B-4F85-87EF-9A390D8C8534}']
    function Passive: Boolean;
    function Disabled: Boolean;
    function Enchanted: Boolean;
    function Range: Integer;
    function IsAura: Boolean;
    function L2Class: TL2Class;
  end;

  IL2Item = interface(IL2Object)
  ['{7744FF23-4B3F-4FB6-A168-A5511ED2795C}']
    function Slot: Cardinal;
    function Count: Int64;
    function Equipped: Boolean;
    function ItemType: Cardinal;
    function Grade: Cardinal;
    function GradeName: string;
    function IsNamed: Boolean;
    function BodyPart: Cardinal;
    function EnchantLevel: Cardinal;
    function AugmentID: Cardinal;
    function AugmentID2: Cardinal;
    function RemainTime: Cardinal;
    function AtkElem: Word;
    function ElemPower: Word;
    function WaterPower: Word;
    function FirePower: Word;
    function EartPower: Word;
    function WindPower: Word;
    function UnholyPower: Word;
    function HolyPower: Word;
    function L2Class: TL2Class;
  end;


  IL2ShopItem = interface(IL2Item)
  ['{1667955B-7556-4A8E-BDB8-4A71C9EB7346}']
    function Price: Int64;
  end;

  ILearnItem = interface(IL2Skill)
  ['{CC575B13-1055-4A2D-AD8C-94476B7587E0}']
    function NeedLevel: Cardinal;
    function MaxLevel: Cardinal;
    function SpCost: Cardinal;
    function Requirements: Cardinal;
    function Group: Cardinal;
  end;

  IConfirmDlg = interface
  ['{067EA1EC-437D-49EF-9E5B-8AD8A86BF1E7}']
    function MsgID: Cardinal;
    function ReqID: Cardinal;
    function Sender: string;
    function EndTime: Cardinal;
    function Valid: Boolean;
  end;

  IChatMessage = interface
  ['{32E96C1E-3E3B-427C-B199-DF0646C43E49}']
    function OID: Cardinal;
    function Time: Cardinal;
    function Sender: string;
    function Text: string;
    function ChatType: TMessageType;
    function UnRead: Boolean;
    procedure SetText(text: string; Color: Cardinal = 0);
  end;

  IMessages = interface
  ['{4255026E-71B7-49C1-BCC2-6A442F8A6151}']
    function GetMaxCount: Integer;
    procedure SetMaxCount(value: integer);
    procedure Add(const Sender, Text: string; MessageType: TMessageType; Color: Integer = -1);
    procedure ClearList(MessageType: TMessageType);
    procedure Clear(All: Boolean = True; MessageType: TMessageType = mtAll);
    procedure SaveToFile(const FileName: string; MessageType: TMessageType);
    function CanRead(MessageType: TMessageType): Boolean;
    function SetRead(MessageType: TMessageType): Boolean;
    function Count(MessageType: TMessageType): Integer;
    property MaxCount: Integer read GetMaxCount write SetMaxCount;
    function IGetMessage(Index: Integer; MessageType: TMessageType): IChatMessage;
    property Items[Index: Integer; MessageType: TMessageType]: IChatMessage read IGetMessage;
  end;

  IL2StaticObject = interface(IL2Object)
    ['{35F539C6-98A8-4684-A993-F18926F71468}']
    function ObjectType: Cardinal;
    function IsTargetable: Cardinal;
    function MeshIndex: Cardinal;
    function IsClosed: Cardinal;
    function IsEnemy: Cardinal;
    function CurHP: Cardinal;
    function MaxHP: Cardinal;
    function IsSHowHP: Cardinal;
    function DamageGrade: Cardinal;
  end;

  /////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////  L2LIST ////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////

  IL2List = interface
  ['{52130AF5-0B16-4F99-8C25-4B3162A4A2C4}']
    function GetCount: Integer;
    function IGetObj(Index: Integer): IL2Object;
    function IByIndex(Index: Integer; var Obj: IL2Object): Boolean;
    function IByID(ID: Cardinal; var Obj: IL2Object): Boolean;
    function IByOID(OID: Cardinal; var Obj: IL2Object): Boolean;
    function IByName(const Name: string; var Obj: IL2Object): Boolean;
    property Count: Integer read GetCount;
    property ByIndex[index: Integer; var Obj: IL2Object]: Boolean read IByIndex;
    property ByID[ID: Cardinal; var Obj: IL2Object]: Boolean read IByID;
    property ByOID[OID: Cardinal; var Obj: IL2Object]: Boolean read IByOID;
    property ByName[const Name: string; var Obj: IL2Object]: Boolean read IByName;
    property Items[index: Integer]: IL2Object read IGetObj; default;
  end;

  ISpawnList = interface(IL2List)
  ['{EE614A44-7BC1-4215-A75A-703241B68350}']
    function IGetItem(Index: Integer): IL2Spawn;
    property Items[index: Integer]: IL2Spawn read IGetItem; default;
  end;

  ICharList  = interface(ISpawnList)
  ['{7798BD56-333A-4832-82E8-375431D15524}']
    function IGetItem(Index: Integer): IL2Char;
    property Items[index: Integer]: IL2Char read IGetItem; default;
  end;

  INpcList   = interface(ISpawnList)
  ['{3871B6AB-ED8A-4551-BC5C-27C6068ED421}']
    function IGetItem(Index: Integer): IL2Npc;
    property Items[index: Integer]: IL2Npc read IGetItem; default;
  end;

  IPetList   = interface(ISpawnList)
  ['{8A1EB19A-5712-4DB5-811E-C0E822AB26FB}']
    function IGetItem(Index: Integer): IL2Pet;
    property Items[index: Integer]: IL2Pet read IGetItem; default;
  end;

  IDropList  = interface(ISpawnList)
  ['{53578904-9F0C-4994-A2F5-D401F91D1AA0}']
    function IGetItem(Index: Integer): IL2Drop;
    property Items[index: Integer]: IL2Drop read IGetItem; default;
  end;

  IItemList  = interface(IL2List)
  ['{009CBD88-B708-4368-9D5F-D4D6B2A7A09D}']
    function IGetItem(Index: Integer): IL2Item;
    property Items[index: Integer]: IL2Item read IGetItem; default;
  end;

  ISkillList = interface(IL2List)
  ['{2CADF468-FE13-4755-A2A9-D8FC251829B6}']
    function IGetItem(Index: Integer): IL2Skill;
    property Items[index: Integer]: IL2Skill read IGetItem; default;
  end;

  IBuffList  = interface(IL2List)
  ['{FF638521-0197-465E-9511-C98F7537808B}']
    function IGetItem(Index: Integer): IL2Buff;
    property Items[index: Integer]: IL2Buff read IGetItem; default;
  end;

  ILearnList = interface(IL2List)
  ['{C582CA00-3A07-4F94-A9D5-3C24557829F0}']
    function IGetItem(Index: Integer): ILearnItem;
    property Items[index: Integer]: ILearnItem read IGetItem; default;
  end;

  IParty = interface
  ['{B5D49125-9939-4880-B99F-7A93CDD2E820}']
    function ByOID(OID: Cardinal; var Obj): Boolean;
    function IsAskJoin: Boolean;
    function LootType: TLootType;
    function LeaderOID: Cardinal;
    function AskJoinName: string;
    function AskJoinTime: Cardinal;
    function GetPets: INpcList;
    function GetChars: ICharList;
    function GetLeader: IL2Char;
    property Pets: INpcList read GetPets;
    property Chars: ICharList read GetChars;
    property Leader: IL2Char read GetLeader;
  end;

  IInventory = interface
  ['{D68D49B0-3339-49EC-81F9-BABB46CE1937}']
    function TotalByID(ItemID: Cardinal; PetItems: Boolean = False): Int64;
    function TotalByName(const ItemName: string; PetItems: Boolean = False): Int64;
    function GetUser: IItemList;
    function GetPet : IItemList;
    function GetQuest: IItemList;
    property User: IItemList read GetUser;
    property Pet: IItemList read GetPet;
    property Quest: IItemList read GetQuest;
  end;

  IL2MailItem = interface(IL2Object)
  ['{A8D01A07-7AAC-453C-BEB5-AB6E34D73259}']
    function IsSent: Boolean;
    function MailType: Cardinal;
    function Title: string;
    function Sender: string;
    function IsLocked: Boolean;
    function Expirate: Cardinal;
    function IsUnread: Boolean;
    function WithItems: Boolean;
    function NoRecvItems: Boolean;
    function IsNews: Boolean;
    function ActualTime: Cardinal;
  end;

  IL2AucItem = interface(IL2Item)
  ['{2E577536-98E7-4BEA-AC3E-2711E31E70A6}']
    function LotType: Cardinal;
    function Seller: string;     // Продавец
    function Price: Int64;       // Цена лота за которую сразу можно выкупить предмет. Если равна 0, то выкупить предмет невозможно
    function Days: Cardinal;
    function EndTime: Cardinal;  // Время до завершения торгов в секундах
  end;

  IL2Auction = interface(IL2List)
  ['{D4685174-6623-46C0-B8D3-BBF9F9813081}']
    function Search(const Name: string; Grade: Integer = -1; PageID: Integer = 0): Boolean; // Grade: 0 - NG; 1 - D,.., 10 - R99.
    function SellItem(Item: IL2Item; Count, Price, Days: Cardinal; CustomName: string = ''): Boolean; // Days: 1, 3, 5, 7
    function BuyItem(Item: IL2AucItem): Boolean;
    function GetMySales: Boolean; // получить список своих лотов продажи
    function CancelItem(Item: IL2AucItem): Boolean;  // снимет предмет с продажи
    function IGetItem(Index: Integer): IL2AucItem;
    property Items[index: Integer]: IL2AucItem read IGetItem; default;
  end;

  IL2StaticList = interface(IL2List)
  ['{10670382-8464-443D-8AE2-9037CC69FED4}']
    function IGetItem(Index: Integer): IL2StaticObject;
    property Items[index: Integer]: IL2StaticObject read IGetItem; default;
  end;

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///
  ///                                                         ENGINE
  ///
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  IBotList = interface;
  IBot = interface;

  IL2Control = interface
  ['{5D626A2C-377F-4C1D-A640-D52C29C71179}']
    function WaitAction(Action: TL2Action; TimeOut: Cardinal = 5000): Boolean;
    procedure Msg(const Sender, Text: string; Color: Integer = -1);
    function WaitAction2(Actions: TL2Actions; var Prm1, Prm2; TimeOut: Cardinal = INFINITE): TL2Action;
    /////////////////////////////////////////////////
    function IGetUser: IL2User;
    function IGetParty: IParty;
    function IGetSkillList: ISkillList;
    function IGetInventory: IInventory;
    function IGetDropList: IDropList;
    function IGetNpcList: INpcList;
    function IGetCharList: ICharList;
    function IGetPetList: IPetList;
    function IGetAuction: IL2Auction;
    function IGetWareHouse: IL2List;
    function IGetItemList: IInventory;
    function IGetChatMessage: IChatMessage;
    function IGetLearnList: ILearnList;
    function IGetLearnList2: ILearnList;
    function IGetHistory: IMessages;
    function IGetStaticList: IL2StaticList;
    function IGetBot: IBot;
    function IGetBotList: IBotList;
    function IGetSysPackets: IL2List;
    /////////////////////////////////////////////////
    function Delay(MS: Cardinal): Boolean;
    function SetPerform(Value: Cardinal): Boolean;
    function SendActID(Value: Cardinal): Boolean;
    function Action(OID: Cardinal; Shift: Boolean = False): Boolean;
    function ForceAtk(OID: Cardinal; CtrlShift: Boolean = False): Boolean;
    function Attack(Ctrl: Boolean = False): Boolean;
    function SAttack(TimeOut: Cardinal = 2000; Ctrl: Boolean = False): Boolean;
    function AltBuff(BuffList: string): Boolean;
    function UseAction(ID: Cardinal; Ctrl: Boolean = False; Shift: Boolean = False): Boolean;
    function SetTargetID(ID: Cardinal; TimeOut: Cardinal = TARGET_TIME): Boolean;
    function SetTarget(OID: Cardinal; TimeOut: Cardinal = TARGET_TIME): Boolean; overload;
    function SetTarget(const Name: string; TimeOut: Cardinal = TARGET_TIME): Boolean; overload;
    function SetTarget(L2Live: IL2Live; TimeOut: Cardinal = TARGET_TIME): Boolean; overload;
    function CancelTarget: Boolean;
    function Assist(const Name: string): Boolean;
    function Sit: Boolean;
    function Stand: Boolean;
    function Status: TL2Status;
    function DismissPet: Boolean;
    function DismissSum: Boolean;
    function GoHome(ResType: TRestartType = rtTown) : Boolean;
    function Restart: Boolean;
    function DRestart: Boolean;
    function GameClose: Boolean;
    function GameStart(CharIndex: Integer = -1): Boolean;
    function BlinkWindow(BlinkGame: Boolean = True): Boolean;
    function DAutoSoulShot(ID: Cardinal; Active: Boolean): Boolean;
    function AutoSoulShot(ID: Cardinal; Active: Boolean): Boolean; overload;
    function AutoSoulShot(const Name: string; Active: Boolean): Boolean; overload;
    function BypassToServer(s: string; IsBypass: Boolean = True): Boolean;
    function UseItemOID(OID: Cardinal; Pet: Boolean = False; Force: Boolean = False): Boolean; overload;
    function UseItem(ID: Cardinal; Pet: Boolean = False; Force: Boolean = False): Boolean; overload;
    function UseItem(const Name: string; Pet: Boolean = False; Force: Boolean = False): Boolean; overload;
    function UseItem(L2Item: IL2Item; Pet: Boolean = False; Force: Boolean = False): Boolean; overload;
    function MoveItem(const Name: string; Count: Int64; ToPet: Boolean): Boolean;
    function DestroyItem(ID: Cardinal; Count: Int64): Boolean; overload;
    function DestroyItem(Item: IL2Item; Count: Int64): Boolean; overload;
    function DestroyItem(const Name: string; Count: Int64): Boolean; overload;
    function CrystalItem(ID: Cardinal): Boolean; overload;
    function CrystalItem(const Name: string): Boolean; overload;
    function CrystalItem(Item: IL2Item): Boolean; overload;
    function DUseSkill(ID: Cardinal; Ctrl: Boolean = False; Shift: Boolean = False): Boolean;
    function UseSkill(ID: Cardinal; Ctrl: Boolean = False; Shift: Boolean = False): Boolean; overload;
    function UseSkill(const Name: string; Ctrl: Boolean = False; Shift: Boolean = False): Boolean; overload;
    function UseSkill(L2Skill: IL2Skill; Ctrl: Boolean = False; Shift: Boolean = False): Boolean; overload;
    function UseFightSkill(ID: Cardinal; Ctrl: Boolean = False; Shift: Boolean = False): Boolean;
    function UseSkill_(ID: Cardinal; Ctrl: Boolean = False; Shift: Boolean = False; Fight: Boolean = False): Boolean;
    function Dispel(const Name: string; Obj: IL2Live = nil): Boolean; overload;
    function Dispel(ID: Cardinal; Obj: IL2Live = nil): Boolean; overload;
    function DLearnSkill(ID: Cardinal; var Info: string): Boolean;
    function LearnSkill(ID: Cardinal): Boolean;
    function Pickup(Obj: IL2Drop; APet: Boolean = False): Boolean; overload;
    function Pickup(Range: Cardinal = 1000; ZRange: Cardinal = 500; OnlyMy: Boolean = True; APet: Boolean = False): Integer; overload;
    function Equipped(const Name: string): Integer;
    function QuestStatus(QuestID: Cardinal; Step: Integer): Boolean;
    function QuestStatus2(ID: Integer): Integer;
    function DlgText: string;
    function DlgTime: Cardinal;
    function HlpText: string;
    function HlpTime: Cardinal;
    function DlgOpen(TimeOut: Cardinal = 7000): Boolean;
    function DlgSel(const Txt: string; TimeOut: Cardinal = 2500): Boolean; overload;
    function DlgSel(Index: Integer; TimeOut: Cardinal = 2500): Boolean; overload;
    function LeaveParty: Boolean;
    function InviteParty(const Name: string; Loot: TLootType = ldLooter): Boolean;
    function JoinParty(Answer: Boolean = True): Boolean;
    function SetPartyLeader(const Name: string): Boolean;
    function DismissParty(const Name: string): Boolean;
    function ConfirmDialog(Accept: Boolean): Boolean;
    function MoveTo(X, Y, Z: Integer; TimeOut: Cardinal = 5000): Boolean; overload;
    function MoveTo(Obj: IL2Spawn; Dist: Integer = -70): Boolean; overload;
    function MoveToTarget(Dist: Integer = -70): Boolean;
    function DMoveTo(X, Y, Z: Integer): Boolean;  // Direct
    function NpcTrade(Sell: Boolean; items: array of Cardinal): Boolean;
    function NpcExchange(ID, Count: Cardinal; ByIndex: Boolean = False): boolean;
    function SendMail(const Recipient, Theme, Content: string; Items: array of Cardinal; Price: Int64 = 0): Boolean;
    function DropItem(ID: Cardinal; Count: Int64; X: Integer = -1; Y: Integer = -1; Z: Integer = -1): Boolean;
    function IsBusy(Obj: IL2Npc): Boolean;
    function IsMyGroup(OID: Cardinal): Boolean;
    function IsEnemy(Obj: IL2Live): Boolean;
    function FindEnemy(var Enemy: IL2Live; Obj: IL2Live; Range: Cardinal = 2500; ZRange: Cardinal = 500): Boolean;
    function AutoTarget(Range: Cardinal = 2500; ZRange: Cardinal = 500; NotBusy: Boolean = True): Boolean;
    procedure Ignore(Obj: IL2Object);
    procedure ClearIgnore;
    procedure ClearZone;
    function InZone(X, Y, Z: Integer): Boolean; overload;
    function InZone(Obj: IL2Spawn): Boolean; overload;
    function LoadConfig(const Name: string): Boolean;
    function LoadZone(const Name: string): Boolean;
    function FaceControl(ID: Integer; Active: Boolean): Boolean;
    function GetFaceState(ID: Integer): Boolean;
    function UseKey(Key: Word; DownUp: Byte = 0): Boolean; overload; // 0 -DownUp 1- Down 2 - Up
    function UseKey(const Key: string; DownUp: Byte = 0): Boolean; overload;
    function EnterText(const Txt: string): Boolean;
    function OpenQuestion: Boolean;
    function Say(const Text: string; ChatType: Cardinal = 0; const Nick: string = ''): Boolean;
    function UpdateSkillList: Boolean;
    function ServerTime: Cardinal;
    function GameTime: Cardinal;
    function IsDay: Boolean;
    function GameWindow: Cardinal;
    function BotWindow: Cardinal;
    function MakeItem(Index: Integer): Boolean;
    function BypassUserCmd(ID: Cardinal): Boolean;
    function UnStuck: Boolean;
    function IGetConfirmDlg: IConfirmDlg;
    function StopCasting: Boolean;
    function InitKey: Boolean;
    function FindPath(StartX, StartY, EndX, EndY: Integer; PathList: TList): Boolean;
    function SendMessage(Msg: Cardinal; wParam, lParam: Integer): Integer;
    function PostMessage(Msg: Cardinal; wParam, lParam: Integer): Integer;
    function SendToServer(const Packet: string): Boolean; overload;
    function SendToServer(const Packet; Size: Word): Boolean; overload;
    function GameVersion: Integer;
    function AuctionSearch(const Name: string; Grade: Integer = -1; PageID: Integer = 0): Boolean; // Grade: 0 - NG; 1 - D,.., 10 - R99.
    function AuctionSellItem(Item: IL2Item; Count, Price, Days: Cardinal; CustomName: string = ''): Boolean; // Days: 1, 3, 5, 7
    function AuctionBuyItem(Item: IL2AucItem): Boolean;
    function AuctionGetMySales: Boolean; // получить список своих лотов продажи
    function AuctionCancelItem(Item: IL2AucItem): Boolean;  // снимет предмет с продажи
    function LoadItems(ToWH: Boolean; Items: array of Cardinal): Boolean;
    function CreateRoom(Text: string; LevelStart, LevelEnd: Integer): Boolean;
    function CloseRoom: Boolean;
    function GetDailyItems: Boolean;
    function UseSkillGround(ID: Cardinal; X, Y, Z: Integer; Ctrl: Boolean = False; Shift: Boolean = False): Boolean;
    function GameHash: Cardinal;
    function GameHash2: string;
    function GetMailItems(MaxLoad: Cardinal = 65; MaxCount: Cardinal = 1000): Boolean;
    function ClearMail: Boolean;
    function SetGameWindow(Visible: Boolean): Boolean;
    function PrivateStoreList(PriceList: array of Cardinal; Sell: Boolean = false): string;
    function OpenPrivateStore(PriceList: array of Cardinal; StoreType: Byte; StoreMsg: string): Boolean;
    function CancelQuest(ID:Integer):boolean;
    function KickMentor: Boolean;
    function InviteMentor(const Name: string): Boolean;
    function GetMentor: string;
    function CastleTax(TownID: Cardinal): Integer;
    procedure AutoAcceptMentors(Names: string);
    procedure AutoAcceptClan(Names: string);
    procedure AutoAcceptCC(Names: string);
    procedure SetMapKeepDist(Value: Integer);
    function GetZoneName(X, Y, Z: Integer): string;
    function GetZoneID(X, Y, Z: Integer): Integer;
    function GetFaceSet(ID: Integer): Pointer;
    function CBText: string;
    function CBTime: Cardinal;
    procedure HKPauseScript(Value: Boolean);
    function SendToClient(const Packet: string): Boolean;
    function GamePrint(Text: string; Nick: string = ''; Chat: Integer = 0): Boolean;
    function UpdateDailyList: Boolean;
    function GetDailyItem(ID: Cardinal): Boolean;
    function GetCaptha: TMemoryStream;
    function GetBotStatus: Integer;
    function GetBaseNpc(ID: Cardinal; var Name: string; var Spd1, Spd2: Integer): Boolean;
    function GetBaseItem(ID: Cardinal; var Name: string): Boolean;
    function GetBaseSkill(ID, LVL: Cardinal; var Name, ICOName: string; var R, MP, OP: Integer): Boolean;
    function UpdateCfg(Wait: Boolean): Boolean;
    function GetServerIP: string;
    function GetHWCount: Cardinal;
    function BlockPacket(ID, ID2: Word; IsServerPacket: boolean; Time: Cardinal = INFINITE): Boolean;
    function WaitOnline(Value: Boolean): Boolean;
    function IsClassicServer: Boolean;
    function GetZOnePoint(Index: Integer): Pointer;
    function SetDebug(Value: Boolean): Boolean;
    function GetZoneType: TZoneType;
    function AuthLogin(const account, password: string): Boolean;
    function Version: string;
    function LoginStatus: Integer;
    function Teleport(ID: Cardinal; ServerType1: Boolean = false): Boolean;
    function GetServerID: Integer;
    function GetServerName: string;
    function GetStatInfo: string;
    function GamePath: string;
    function GameProtocol: Integer;
    function CharSelectionInfo: Pointer;
    function CallMouse(Button: BYTE; X, Y, Wheel: ShortInt): Boolean;
    function KeyPress(Key: BYTE): Boolean;
    function KeyRelease: Boolean;
    procedure Lock;
    procedure UnLock;
    function AccountSelected: Boolean;
    function GetBaseIconHandle(ID, IsItem: Integer): THandle;
    function UseProxy(ProxyType: BYTE; IP, Port, User, Password: string): Boolean;
    function AccessInfo: Int64;
    function GetPacket(var Packet: string): Integer; // start packets queue. result 0 - queue is null; 1 - server packet, 2 - client packet
    procedure StopPackets;                           // stop and clear queue
    property User: IL2User read IGetUser;
    property Party: IParty read IGetParty;
    property SkillList: ISkillList read IGetSkillList;
    property Inventory: IInventory read IGetInventory;
    property DropList: IDropList read IGetDropList;
    property NpcList: INpcList read IGetNpcList;
    property CharList: ICharList read IGetCharList;
    property PetList: IPetList read IGetPetList;
    property Auction: IL2Auction read IGetAuction;
    property WareHouse: IL2List read IGetWareHouse;
    property ItemList: IInventory read IGetItemList;
    property ChatMessage: IChatMessage read IGetChatMessage;
    property LearnList: ILearnList read IGetLearnList;
    property LearnList2: ILearnList read IGetLearnList2;
    property History: IMessages read IGetHistory;
    property ConfirmDlg: IConfirmDlg read IGetConfirmDlg;
    property StaticList: IL2StaticList read IGetStaticList;
    property SysPackets: IL2List read IGetSysPackets;
    property Bot: IBot read IGetBot;
    property BotList: IBotList read IGetBotList;
  end;

  IGps = interface;

  IBot = interface
  ['{F5E3C797-E244-40F3-BE07-67889BB2836E}']
    procedure SetAutoAttack(arg: Boolean);
    procedure SetAutoHeal(arg: Boolean);
    procedure SetAutoBuff(arg: Boolean);
    procedure SetAutoEvent(arg: Boolean);
    procedure SetAutoScript(arg: Boolean);
    procedure SetAutoScriptPath(arg: string);
    procedure SetNewName(Value: string);
    procedure SetActive(arg: Boolean);
    function GetAutoScript: Boolean;
    function GetAutoScriptPath: string;
    function GetUserName: string;
    function GetAutoAttack: Boolean;
    function GetAutoHeal: Boolean;
    function GetAutoBuff: Boolean;
    function GetAutoEvent: Boolean;
    function GetGameWindow: HWND;
    function GetGamePath: string;
    function GetNewName: string;
    function iGetBotList: IBotList;
    function iGetControl: IL2Control;
    function iGetMessages: IMessages;
    function GetActive: Boolean;
    function GetConnected: Boolean;
    function GetStatus: TL2Status;
    function LoadConfig(const Name: string): Boolean;
    ///////////////////////////////////////////////////////////////////////////
    procedure SetGameWindow(hWindow: HWND);
    function  LoadConfigMain(const Name: string): Boolean;
    function  LoadZoneMain(const Name: string): Boolean;
    procedure ClearZoneMain;
    procedure FaceControlMain(ButtonID: Integer; Active: Boolean);
    procedure ShowMain;
    procedure ActivateSingle;
    procedure ActivateGroup;
    procedure ShowBot(ShowFace: Boolean = True);
    function ExePath: string;
    function GETHWID: Cardinal;
    function GetScriptHWID: string;
    function GetHardwareID: string;
    function GetControl(Nick: string): IL2Control;
    function GetControlByIndex(Index: Integer): IL2Control;
    function LanguageID: Cardinal;
    ////// Script control ///////
    procedure ScriptRun;
    procedure ScriptStop;
    function ScriptStatus: TScriptStatus;
    function ScriptLoad(const Name: string): Boolean;
    function ScriptReplace(const Name: string): Boolean;
    function ScriptPath: string;
    function StartPlugin(const Name: string): Boolean;
    function StopPlugin(const Name: string): Boolean;
    function StopPlugins: Boolean;
    function GetPluginStatus(const Name: string): Integer;
    function MainProc(Proc: TThreadFunc; Parameter: Pointer = nil): Integer;
    function DoEntryScript(var Prm): Boolean;
    function DoEntryPlugin(var Prm): Boolean;
    procedure DisableStatus(Value: Boolean);
    function IGetGPS: IGPS;
    function IGetGPS1: IGPS;
    function IGetGPS2: IGPS;
    function IGetGPS3: IGPS;
    procedure DoPacket(Pck: Pointer; Size: Cardinal);
    ////////////////////////////
    property Connected: Boolean read GetConnected;
    property BotList: IBotList read iGetBotList;
    property Control: IL2Control read iGetControl;
    property GameWindow: HWND read GetGameWindow;
    property GamePath: string read GetGamePath;
    property Active: Boolean read GetActive write SetActive;
    property AutoAttack: Boolean read GetAutoAttack write SetAutoAttack;
    property AutoHeal: Boolean read GetAutoHeal write SetAutoHeal;
    property AutoBuff: Boolean read GetAutoBuff write SetAutoBuff;
    property AutoEvent: Boolean read GetAutoEvent write SetAutoEvent;
    property UserName: string read GetUserName;
    property NewName: string read GetNewName write SetNewName;
    property AutoScript: Boolean read GetAutoScript write SetAutoScript;
    property AutoScriptPath: string read GetAutoScriptPath write SetAutoScriptPath;
    property History: IMessages read IGetMessages;
    property Status: TL2Status read GetStatus;
    property GPS: IGPS read IGetGPS;
    property GPS1: IGPS read IGetGPS1;
    property GPS2: IGPS read IGetGPS2;
    property GPS3: IGPS read IGetGPS3;
  end;

  IBotList = interface
  ['{D35C3BC7-5C5F-4533-A602-11CDB3A08B2B}']
    function iGetBot(Index: Integer): IBot;
    function GetCount: Integer;
    property Count: Integer read GetCount;
    property Items[index: Integer]: IBot read iGetBot; default;
  end;


  TGpsPoint = class
    FX, FY, FZ: Single;
    FID: Integer;
    FName: widestring;
    FR: Single;
  public
    function X: Single;
    function Y: Single;
    function Z: Single;
    function ID: Integer;
    function Name: widestring;
    function R: Single;
  end;

  TGpsList = class(TList)
    function GetPoint(Index: Integer): TGpsPoint;
  public
    destructor Destroy; override;
    procedure Clear;
    property Items[index: Integer]: TGpsPoint read GetPoint;  default;
  end;

  IGps = interface
  ['{40358F78-F7F0-4CF7-A7C3-536F748AFBBC}']
    procedure Clear;
    function Count: Integer;
    function LoadBase(const FilePath: String): integer;
    function GetPath(PSX, PSY, PSZ, PEX, PEY, PEZ: Single): Single;
    function GetPathByName(PSX, PSY, PSZ: Single; PointName: String): Single;
    function GetPoint(Name: String; var X, Y, Z: Single): Boolean;
    function Items(index: Integer): TGpsPoint;
    function GetPathList: TGpsList;
    function GetBaseList: TGpsList;
    property Path: TGpsList read GetPathList;
    property Base: TGpsList read GetBaseList;
  end;

function MemToHex(const dt; size: Word; sep: char = #0): String;

implementation

function MemToHex(const dt; size: Word; sep: char = #0): String;
const
  hexAlf: array[0..15] of Char = '0123456789ABCDEF';
var
  i: Integer;
  str1: array[0..0] of Byte absolute dt;
begin
  if sep = #0 then
  begin
    SetLength(Result, size * 2);
    for i := 0 to size - 1 do
    begin
      Result[i * 2 + 1] := hexAlf[str1[i] shr $4];
      Result[i * 2 + 2] := hexAlf[str1[i] and $f];
    end;
  end
  else
  begin
    SetLength(Result, size * 3);
    for i := 0 to size - 1 do
    begin
      Result[i * 3 + 1] := hexAlf[str1[i] shr $4];
      Result[i * 3 + 2] := hexAlf[str1[i] and $f];
      Result[i * 3 + 3] := sep;
    end;
  end;
end;

function TGpsPoint.X: Single;
begin
  Result := FX;
end;

function TGpsPoint.Y: Single;
begin
  Result := FY;
end;

function TGpsPoint.Z: Single;
begin
  Result := FZ;
end;

function TGpsPoint.ID: Integer;
begin
  Result := FID;
end;

function TGpsPoint.Name: widestring;
begin
  Result := FName;
end;

function TGpsPoint.R: Single;
begin
  Result := FR;
end;

destructor TGpsList.Destroy;
begin
  Self.Clear;
  Inherited Destroy;
end;

procedure TGpsList.Clear;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].Free;
  Inherited Clear;
end;

function TGpsList.GetPoint(Index: Integer): TGpsPoint;
begin
  Result := TGpsPoint(inherited Items[Index]);
end;

end.
