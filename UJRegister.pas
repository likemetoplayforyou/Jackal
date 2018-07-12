unit UJRegister;

interface

uses
  Classes, Generics.Collections,
  UJCell, UJUnit;

type
  TJUnitTypeRegistry = TObjectDictionary<TJUnitType, TJUnitTypeInfo>;


  TJCellTypeRegistry = class(TObject)
  private
    FDictionary: TDictionary<TJCellType, TJCellTypeInfo>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(ACellType: TJCellType; ACellTypeInfo: TJCellTypeInfo);
    function TryGetCellInfo(
      ACellType: TJCellType; out AResult: TJCellTypeInfo): boolean;
    function TryGetCellClass(
      ACellType: TJCellType; out AResult: TJCellClass): boolean;
    function TryCreateCellByType(
      ACellType: TJCellType; AOwner: TComponent; out AResult: TJCell): boolean;
  end;


var
  UnitRegistry: TJUnitTypeRegistry;
  CellRegistry: TJCellTypeRegistry;

implementation

uses
  Graphics;


{ TJCellTypeRegistry }

procedure TJCellTypeRegistry.Add(
  ACellType: TJCellType; ACellTypeInfo: TJCellTypeInfo);
begin
  FDictionary.Add(ACellType, ACellTypeInfo);
end;


constructor TJCellTypeRegistry.Create;
begin
  inherited Create;
  FDictionary :=
    TObjectDictionary<TJCellType, TJCellTypeInfo>.Create([doOwnsValues]);
end;


function TJCellTypeRegistry.TryCreateCellByType(
  ACellType: TJCellType; AOwner: TComponent; out AResult: TJCell): boolean;
var
  info: TJCellTypeInfo;
begin
  Result := FDictionary.TryGetValue(ACellType, info);
  if not Result then
    Exit;

  AResult := info.CellClass.Create(AOwner);
  try
    AResult.SetInfo(info);
    AResult.Init;
  except
    AResult.Free;
    raise;
  end;
end;


function TJCellTypeRegistry.TryGetCellClass(
  ACellType: TJCellType; out AResult: TJCellClass): boolean;
var
  info: TJCellTypeInfo;
begin
  Result := TryGetCellInfo(ACellType, info);
  if Result then
    AResult := info.CellClass;
end;


function TJCellTypeRegistry.TryGetCellInfo(
  ACellType: TJCellType; out AResult: TJCellTypeInfo): boolean;
begin
  Result := FDictionary.TryGetValue(ACellType, AResult);
end;


destructor TJCellTypeRegistry.Destroy;
begin
  FDictionary.Free;
  inherited;
end;


initialization
  UnitRegistry := TJUnitTypeRegistry.Create([doOwnsValues]);
  CellRegistry := TJCellTypeRegistry.Create;

  UnitRegistry.Add(utRed, TJUnitTypeInfo.Create(tRed, clRed));
  UnitRegistry.Add(utBlack, TJUnitTypeInfo.Create(tBlack, clBlack + 1));
  UnitRegistry.Add(utYellow, TJUnitTypeInfo.Create(tYellow, clYellow));
  UnitRegistry.Add(utWhite, TJUnitTypeInfo.Create(tWhite, clWhite));

  CellRegistry.Add(ctShipRed, TJShipTypeInfo.Create('imgShipRed', utRed));
  CellRegistry.Add(ctShipBlack, TJShipTypeInfo.Create('imgShipBlack', utBlack));
  CellRegistry.Add(ctShipYellow, TJShipTypeInfo.Create('imgShipYellow', utYellow));
  CellRegistry.Add(ctShipWhite, TJShipTypeInfo.Create('imgShipWhite', utWhite));
  CellRegistry.Add(ctLand, TJCellTypeInfo.Create(TJLandCell, 'imgLand'));
  CellRegistry.Add(ctEmpty1, TJCellTypeInfo.Create(TJEmptyCell, 'imgEmpty1'));
  CellRegistry.Add(ctEmpty2, TJCellTypeInfo.Create(TJEmptyCell, 'imgEmpty2'));
  CellRegistry.Add(ctEmpty3, TJCellTypeInfo.Create(TJEmptyCell, 'imgEmpty3'));
  CellRegistry.Add(ctEmpty4, TJCellTypeInfo.Create(TJEmptyCell, 'imgEmpty4'));

{
  CellDictionary.Add(ctDoubleMove, TJDoubleMoveCell);
  CellDictionary.Add(ctOneArrowPlain, TJOneArrowPlainCell);
  CellDictionary.Add(ctOneArrowDiagonal, TJOneArrowDiagonalCell);
  CellDictionary.Add(ctTwoArrowsPlain, TJTwoArrowsPlainCell);
  CellDictionary.Add(ctTwoArrowsDiagonal, TJTwoArrowsDiagonalCell);
  CellDictionary.Add(ctThreeArrows, TJThreeArrowsCell);
  CellDictionary.Add(ctFourArrowsPlain, TJFourArrowsPlainCell);
  CellDictionary.Add(ctFourArrowsDiagonal, TJFourArrowsDiagonalCell);
  CellDictionary.Add(ctTrap, TJTrapCell);
  CellDictionary.Add(ctMaze2Turns, TJMaze2TurnsCell);
  CellDictionary.Add(ctMaze3Turns, TJMaze3TurnsCell);
  CellDictionary.Add(ctMaze4Turns, TJMaze4TurnsCell);
  CellDictionary.Add(ctMaze5Turns, TJMaze5TurnsCell);
  CellDictionary.Add(ctRumBarrel, TJRumBarrelCell);
  CellDictionary.Add(ctCrocodile, TJCrocodileCell);
  CellDictionary.Add(ctBalloon, TJBalloonCell);
  CellDictionary.Add(ctCannon, TJCannonCell);
  CellDictionary.Add(ctCoinsChest1, TJCoinsChest1Cell);
  CellDictionary.Add(ctCoinsChest2, TJCoinsChest2Cell);
  CellDictionary.Add(ctCoinsChest3, TJCoinsChest3Cell);
  CellDictionary.Add(ctCoinsChest4, TJCoinsChest4Cell);
  CellDictionary.Add(ctCoinsChest5, TJCoinsChest5Cell);
  CellDictionary.Add(ctHorse, TJHorseCell);
  CellDictionary.Add(ctCitadel, TJCitadelCell);
  CellDictionary.Add(ctAboriginal, TJAboriginalCell);
  CellDictionary.Add(ctAirplane, TJAirplaneCell);
  CellDictionary.Add(ctCannibal, TJCannibalCell);
}

finalization
  CellRegistry.Free;
  UnitRegistry.Free;

end.
