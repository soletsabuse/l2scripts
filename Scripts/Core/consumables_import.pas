unit Consumables;

// Supply purchasing for Rift and standalone scripts.
// Inventory is refreshed through the bot API before planning and after each purchase;
// no inventory or multisell response packets are parsed.
interface

type
  TConsumable = record
    Name: string;
    Minimum, Maximum: Int64;
  end;

function Consumable(Name: string; Minimum, Maximum: Int64): TConsumable;
function ConsumablesCheckList(const Items: array of TConsumable): Boolean;
function ConsumablesCheck(Name: string; Minimum, Maximum: Int64): Boolean;
function ConsumablesClearError: Boolean;
procedure ConsumablesOnAction(Action: TL2Action; P1, P2: Pointer);
procedure ConsumablesFree;

implementation

uses SysUtils;

const
  SP_MAX_ITEMS = 200;
  SP_MAX_STACKS = 4096;
  SP_MULTISELL_ID = 7300;
  SP_SHOP_OPEN = 'PremShopList';
  SP_MULTISELL_OPEN = '_bbs_multisell?id=7300';
  SP_REFRESH_WAIT_MS = 1500;
  SP_BUY_WAIT_MS = 4000;
  SP_DEBUG = False;

type
  TSPProduct = record
    Name: string;
    ItemID, EntryID: Cardinal;
    Price, Batch: Int64;
  end;
  TSPStack = record
    OID, ItemID: Cardinal;
    Amount: Int64;
  end;
  TSPRequest = record
    Product: Integer;
    Minimum, Maximum, Needed, Exchanges: Int64;
    Fraction: Double;
    Picked, Skip: Boolean;
  end;

var
  SPProducts: array[0..SP_MAX_ITEMS - 1] of TSPProduct;
  SPProductCount: Integer;
  SPStacks: array[0..SP_MAX_STACKS - 1] of TSPStack;
  SPStackCount: Integer;
  SPRequests: array[0..SP_MAX_ITEMS - 1] of TSPRequest;
  SPInitialized, SPBusy, SPCallFault, SPShopOpened: Boolean;
  SPHasPurchaseTick: Boolean;
  SPLastPurchaseTick: Cardinal;
  SPCharacter, SPPendingCharacter: string;
  SPActor: Cardinal;
  SPPending: Boolean;
  SPPendingProduct: Integer;
  SPPendingExchanges: Int64;

function Consumable(Name: string; Minimum, Maximum: Int64): TConsumable;
begin
  Result.Name := Name;
  Result.Minimum := Minimum;
  Result.Maximum := Maximum;
end;

procedure SPLog(Message: string);
begin
  Print('[SUPPLIES] ' + Message);
end;

procedure SPDebug(Message: string);
begin
  if SP_DEBUG then SPLog(Message);
end;

// This runtime's IntToStr can narrow Int64 to signed 32 bits.
function SPAmountText(Value: Int64): string;
var Digit: Integer; Negative: Boolean;
begin
  Negative := Value < 0;
  if Negative then Value := -Value;
  Result := '';
  repeat
    Digit := Value mod 10;
    Result := IntToStr(Digit) + Result;
    Value := Value div 10;
  until Value = 0;
  if Negative then Result := '-' + Result;
end;

procedure SPAddProduct(Name: string; ItemID, EntryID: Cardinal; Price, Batch: Int64);
begin
  SPProducts[SPProductCount].Name := Name;
  SPProducts[SPProductCount].ItemID := ItemID;
  SPProducts[SPProductCount].EntryID := EntryID;
  SPProducts[SPProductCount].Price := Price;
  SPProducts[SPProductCount].Batch := Batch;
  Inc(SPProductCount);
end;

procedure SPInitialize;
begin
  if SPInitialized then Exit;
  SPProductCount := 0;
  // Name, inventory ItemID, multisell EntryID, price per exchange, items per exchange.
  SPAddProduct('Mana Drug',    726, 105, 35000, 1);
  SPAddProduct('Mana Potion',  728, 103, 40000, 1);
  SPAddProduct('Spirit Ore',  3031,  59,   540, 1);
  SPAddProduct('Arrows S',    1345,  45,   420, 1);
  SPAddProduct('CP',          5592,  99, 50000, 1);
  SPAddProduct('HP',          1539, 101, 20000, 1);
  SPAddProduct('Cursed Bone', 2508,  47,   360, 1);
  SPAddProduct('Soul Ore',   1785,  57,   337, 1);
  SPAddProduct('Energy Stone',5589,  61,   130, 1);
  SPAddProduct('Beast BSS',   6647,  35,   120, 1);
  SPAddProduct('Beast SS',    6645,  31,    24, 1);
  SPAddProduct('BSSS',        3952,  29,   720, 1);
  SPAddProduct('BSSA',        3951,  27,   440, 1);
  SPAddProduct('BSSB',        3950,  25,   245, 1);
  SPAddProduct('BSSC',        3949,  23,    42, 1);
  SPAddProduct('BSSD',        3948,  21,    28, 1);
  SPAddProduct('SSS',         1467,   9,   200, 1);
  SPAddProduct('SSA',         1466,   7,   120, 1);
  SPAddProduct('SSB',         1465,   5,    50, 1);
  SPAddProduct('SSC',         1464,   3,    22, 1);
  SPAddProduct('SSD',         1463,   1,    14, 1);
  SPInitialized := True;
end;

function SPFindProduct(Name: string): Integer;
var I: Integer;
begin
  SPInitialize;
  Result := -1;
  for I := 0 to SPProductCount - 1 do
    if SameText(Trim(Name), SPProducts[I].Name) then
    begin Result := I; Exit; end;
end;

function SPFindStack(OID: Cardinal): Integer;
var I: Integer;
begin
  Result := -1;
  for I := 0 to SPStackCount - 1 do
    if SPStacks[I].OID = OID then
    begin Result := I; Exit; end;
end;

function SPStoreStack(OID, ItemID: Cardinal; Amount: Int64): Boolean;
var I: Integer;
begin
  Result := False;
  if (OID = 0) or (ItemID = 0) or (Amount < 0) or (Amount > 1000000000000000) then Exit;
  I := SPFindStack(OID);
  if I < 0 then
  begin
    if SPStackCount >= SP_MAX_STACKS then Exit;
    I := SPStackCount; Inc(SPStackCount);
    SPStacks[I].OID := OID; SPStacks[I].ItemID := ItemID;
  end
  else if SPStacks[I].ItemID <> ItemID then Exit;
  SPStacks[I].Amount := Amount;
  Result := True;
end;

function SPCount(ItemID: Cardinal): Int64;
var I: Integer;
begin
  Result := 0;
  for I := 0 to SPStackCount - 1 do
    if SPStacks[I].ItemID = ItemID then
    begin
      if SPStacks[I].Amount > 1000000000000000 - Result then
      begin Result := -1; Exit; end;
      Result := Result + SPStacks[I].Amount;
    end;
end;

function SPOnline: Boolean;
begin
  Result := False;
  if Engine.Status <> lsOnline then Exit;
  if User = nil then Exit;
  Result := (User.Name = SPCharacter) and (User.OID = SPActor);
end;

function SPBindCharacter: Boolean;
begin
  Result := False;
  if Engine.Status <> lsOnline then Exit;
  if User = nil then Exit;
  if (SPCharacter = User.Name) and (SPActor = User.OID) then
  begin Result := True; Exit; end;
  SPHasPurchaseTick := False;
  SPShopOpened := False;
  SPCharacter := User.Name; SPActor := User.OID;
  Result := True;
end;

// Read the bot's inventory API after the server has answered RequestItemList.
function SPReadAPI: Boolean;
var Inv: TInventory; I: Integer;
begin
  Result := False;
  Inv := Engine.GetInventory;
  if Inv = nil then Exit;
  SPStackCount := 0;
  for I := 0 to Inv.User.Count - 1 do
    if not SPStoreStack(Inv.User.Items(I).OID, Inv.User.Items(I).ID,
      Inv.User.Items(I).Count) then Exit;
  for I := 0 to Inv.Quest.Count - 1 do
    if SPFindStack(Inv.Quest.Items(I).OID) < 0 then
      if not SPStoreStack(Inv.Quest.Items(I).OID, Inv.Quest.Items(I).ID,
        Inv.Quest.Items(I).Count) then Exit;
  Result := True;
end;

// Same refresh used by the Library farm scripts: request the complete inventory,
// wait for the bot API to update, then count stacks through Engine.GetInventory.
function SPRefreshInventory: Boolean;
begin
  Result := False;
  if not SPOnline or SPCallFault then Exit;
  SPDebug('Request fresh inventory');
  Engine.SendToServer('14');
  if not Delay(SP_REFRESH_WAIT_MS) then Exit;
  if not SPOnline or SPCallFault then Exit;
  Result := SPReadAPI;
end;

function SPOpenShopOnce: Boolean;
begin
  Result := False;
  if not SPOnline or SPCallFault then Exit;
  if SPShopOpened then begin Result := True; Exit; end;
  SPLog('OPEN multisell=' + IntToStr(SP_MULTISELL_ID));
  if not Engine.BypassToServer(SP_SHOP_OPEN) then
  begin SPLog('Cannot open shop; no purchase sent'); Exit; end;
  if not Delay(1000) then Exit;
  if not SPOnline or SPCallFault then Exit;
  if not Engine.BypassToServer(SP_MULTISELL_OPEN) then
  begin SPLog('Cannot request multisell; no purchase sent'); Exit; end;
  if not Delay(1500) then Exit;
  if not SPOnline or SPCallFault then Exit;
  SPShopOpened := True;
  Result := True;
  SPLog('READY multisell=' + IntToStr(SP_MULTISELL_ID));
end;

function SPWaitPurchaseGap: Boolean;
var Elapsed: Cardinal;
begin
  Result := False;
  if not SPOnline or SPCallFault then Exit;
  if SPHasPurchaseTick then
  begin
    Elapsed := GetTickCount - SPLastPurchaseTick;
    if Elapsed < 1000 then
      if not Delay(1000 - Elapsed) then Exit;
  end;
  Result := SPOnline and not SPCallFault;
end;

function SPCreatePending(Product: Integer; Exchanges: Int64): Boolean;
begin
  Result := False;
  if SPPending then
  begin SPLog('Unconfirmed previous purchase; manual review required'); Exit; end;
  SPPendingCharacter := SPCharacter;
  SPPendingProduct := Product;
  SPPendingExchanges := Exchanges;
  SPPending := True;
  Result := True;
end;

procedure SPReportPending;
begin
  SPLog('BLOCKED: previous purchase unconfirmed for ' + SPPendingCharacter +
    '; item=' + SPProducts[SPPendingProduct].Name +
    '; exchanges=' + SPAmountText(SPPendingExchanges));
  SPLog('Check actual stock before manual recovery; no automatic retry during this script run');
end;

function SPExchange(Product: Integer; Exchanges, Minimum, Maximum: Int64): Boolean;
var Amount, Adena, Limit, AfterAmount: Int64; SendAttempted: Boolean;
begin
  Result := False; SendAttempted := False;
  if not SPOnline or SPCallFault then Exit;
  if Exchanges <= 0 then begin Result := True; Exit; end;
  if not SPWaitPurchaseGap then Exit;
  // Refresh before every requested item, as the Library farm script does.
  if not SPRefreshInventory then
  begin SPLog('Cannot refresh inventory before ' + SPProducts[Product].Name); Exit; end;
  Amount := SPCount(SPProducts[Product].ItemID);
  Adena := SPCount(57);
  if (Amount < 0) or (Adena < 0) then Exit;
  if Amount >= Minimum then
  begin
    SPLog('SKIP ' + SPProducts[Product].Name + '; stock=' + SPAmountText(Amount) + '; enough');
    Result := True; Exit;
  end;
  Limit := (Maximum - Amount) div SPProducts[Product].Batch;
  if Exchanges > Limit then Exchanges := Limit;
  Limit := Adena div SPProducts[Product].Price;
  if Exchanges > Limit then Exchanges := Limit;
  if Exchanges <= 0 then
  begin
    SPLog('SKIP ' + SPProducts[Product].Name + ': not enough adena for one exchange');
    Result := True; Exit;
  end;
  if not SPOpenShopOnce then Exit;
  if not SPCreatePending(Product, Exchanges) then Exit;
  try
    if not SPOnline or SPCallFault then Exit;
    SPLog('BUY ' + SPProducts[Product].Name + '; exchanges=' + SPAmountText(Exchanges) +
      '; before=' + SPAmountText(Amount));
    SendAttempted := True;
    // Keep the existing bot API call: this catalog's EntryIDs differ from the
    // Library catalog for some products, so the item ID remains authoritative.
    if not Engine.NpcExchange(SPProducts[Product].ItemID, Cardinal(Exchanges), False) then
    begin SPLog('NpcExchange=False for ' + SPProducts[Product].Name + '; no automatic retry'); Exit; end;
    if not Delay(SP_BUY_WAIT_MS) then Exit;
    if not SPOnline or SPCallFault then Exit;
    if not SPRefreshInventory then
    begin SPLog('Cannot refresh inventory after purchase; no automatic retry'); Exit; end;
    AfterAmount := SPCount(SPProducts[Product].ItemID);
    if (AfterAmount >= Amount) and
      (AfterAmount - Amount >= Exchanges * SPProducts[Product].Batch) then
    begin
      SPPending := False;
      SPLastPurchaseTick := GetTickCount; SPHasPurchaseTick := True;
      SPLog('OK ' + SPProducts[Product].Name + '; stock=' + SPAmountText(AfterAmount));
      Result := True;
    end
    else
      SPLog('Purchase NOT confirmed from refreshed inventory; no retry. Check stock before clearing pending');
  finally
    if not Result and not SendAttempted then SPPending := False;
  end;
end;

procedure SPBuildPlan(RequestCount: Integer);
var I, J, Best: Integer; Current, Budget, Cost, Available: Int64;
  Total, Ratio, Exact: Double;
begin
  Available := SPCount(57);
  if Available < 0 then Available := 0;
  Budget := Available; Total := 0;
  for I := 0 to RequestCount - 1 do
  begin
    J := SPRequests[I].Product;
    SPRequests[I].Needed := 0; SPRequests[I].Exchanges := 0;
    SPRequests[I].Fraction := 0; SPRequests[I].Picked := False;
    Current := SPCount(SPProducts[J].ItemID);
    if (not SPRequests[I].Skip) and (Current >= 0) and
      (Current < SPRequests[I].Minimum) then
      SPRequests[I].Needed := (SPRequests[I].Maximum - Current) div SPProducts[J].Batch;
    Total := Total + Double(SPRequests[I].Needed) * SPProducts[J].Price;
  end;
  Ratio := 0;
  if Total > 0 then
  begin Ratio := Double(Available) / Total; if Ratio > 1 then Ratio := 1; end;
  for I := 0 to RequestCount - 1 do
  begin
    J := SPRequests[I].Product;
    Exact := SPRequests[I].Needed * Ratio;
    SPRequests[I].Exchanges := Trunc(Exact);
    if SPRequests[I].Exchanges > Budget div SPProducts[J].Price then
      SPRequests[I].Exchanges := Budget div SPProducts[J].Price;
    SPRequests[I].Fraction := Exact - SPRequests[I].Exchanges;
    Cost := SPRequests[I].Exchanges * SPProducts[J].Price;
    Budget := Budget - Cost;
  end;
  // At most one rounding exchange per row, largest fractional remainder first.
  for I := 0 to RequestCount - 1 do
  begin
    Best := -1;
    for J := 0 to RequestCount - 1 do
      if not SPRequests[J].Picked then
        if Best < 0 then Best := J
        else if SPRequests[J].Fraction > SPRequests[Best].Fraction then Best := J;
    if Best >= 0 then
    begin
      SPRequests[Best].Picked := True; J := SPRequests[Best].Product;
      if (SPRequests[Best].Exchanges < SPRequests[Best].Needed) and
        (SPProducts[J].Price <= Budget) then
      begin Inc(SPRequests[Best].Exchanges); Budget := Budget - SPProducts[J].Price; end;
    end;
  end;
end;

function ConsumablesCheckList(const Items: array of TConsumable): Boolean;
var I, J, K, RequestCount: Integer; Current, Quantity: Int64;
begin
  Result := False;
  SPInitialize;
  if SPBusy then begin SPLog('Already running; call from one main loop only'); Exit; end;
  RequestCount := High(Items) + 1;
  if RequestCount > SP_MAX_ITEMS then
  begin SPLog('Too many requested items'); Exit; end;
  // Validate the entire list before any inventory request or purchase.
  for I := 0 to RequestCount - 1 do
  begin
    J := SPFindProduct(Items[I].Name);
    if J < 0 then begin SPLog('Unknown catalog name: ' + Items[I].Name); Exit; end;
    if (Items[I].Minimum < 0) or (Items[I].Maximum <= Items[I].Minimum) or
      (Items[I].Maximum > 1000000000) then
    begin SPLog('Invalid minimum/maximum: ' + Items[I].Name); Exit; end;
    if (SPProducts[J].Price <= 0) or (SPProducts[J].Price > 1000000000000) or
      (SPProducts[J].Batch <= 0) or (SPProducts[J].Batch > Items[I].Maximum) then
    begin SPLog('Invalid catalog price/batch: ' + Items[I].Name); Exit; end;
    for K := 0 to I - 1 do
      if SPRequests[K].Product = J then
      begin SPLog('Duplicate item: ' + Items[I].Name); Exit; end;
    SPRequests[I].Product := J; SPRequests[I].Minimum := Items[I].Minimum;
    SPRequests[I].Maximum := Items[I].Maximum; SPRequests[I].Skip := False;
  end;
  if RequestCount = 0 then begin Result := True; Exit; end;
  SPBusy := True; SPCallFault := False;
  try
    try
      if not SPBindCharacter then begin SPLog('Character offline'); Exit; end;
      if (Engine.GameProtocol <> 196) or (Engine.GameVersion <> 669) then
      begin SPLog('Unsupported protocol; expected 196 / 669'); Exit; end;
      if SPPending then begin SPReportPending; Exit; end;
      if not SPRefreshInventory then
      begin SPLog('Cannot read refreshed inventory'); Exit; end;
      for I := 0 to RequestCount - 1 do
      begin
        J := SPRequests[I].Product;
        Current := SPCount(SPProducts[J].ItemID);
        if Current < 0 then Exit;
        SPDebug('API ' + SPProducts[J].Name + '=' + SPAmountText(Current) +
          '; min=' + SPAmountText(SPRequests[I].Minimum) +
          '; max=' + SPAmountText(SPRequests[I].Maximum));
        if Current >= SPRequests[I].Minimum then
          SPLog('SKIP ' + SPProducts[J].Name + '; stock=' + SPAmountText(Current) + '; enough');
      end;
      SPBuildPlan(RequestCount);
      for I := 0 to RequestCount - 1 do
      begin
        J := SPRequests[I].Product; Quantity := SPRequests[I].Exchanges;
        Current := SPCount(SPProducts[J].ItemID);
        if (Quantity = 0) and (Current < SPRequests[I].Minimum) then
          SPLog('SKIP ' + SPProducts[J].Name + ': no affordable exchanges after budget allocation');
        if (Quantity > 0) and (Current < SPRequests[I].Minimum) then
          if not SPExchange(J, Quantity, SPRequests[I].Minimum, SPRequests[I].Maximum) then Exit;
      end;
      Result := True;
    except
      SPLog('Exception; purchases stopped. Any pending transaction remains blocked');
      Result := False;
    end;
  finally SPBusy := False; end;
end;

function ConsumablesCheck(Name: string; Minimum, Maximum: Int64): Boolean;
begin
  Result := ConsumablesCheckList([Consumable(Name, Minimum, Maximum)]);
end;

function ConsumablesClearError: Boolean;
begin
  Result := False; SPInitialize;
  if SPBusy then Exit;
  if not SPBindCharacter then Exit;
  if not SPPending then begin Result := True; Exit; end;
  if SPCharacter <> SPPendingCharacter then
  begin SPLog('Manual recovery requires the original character: ' + SPPendingCharacter); Exit; end;
  SPPending := False; Result := True;
end;

procedure ConsumablesOnAction(Action: TL2Action; P1, P2: Pointer);
begin
  if (Action = laInGame) or (Action = laCharSelect) then
  begin
    if SPBusy then SPCallFault := True;
    SPShopOpened := False;
    SPHasPurchaseTick := False;
    SPCharacter := ''; SPActor := 0;
  end;
end;

procedure ConsumablesFree;
begin
  SPShopOpened := False;
  SPBusy := False;
end;

end.
