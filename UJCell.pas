unit UJCell;

interface

uses
  Classes, Controls, StdCtrls, Generics.Collections, Messages, Buttons,
  Graphics,
  UJUnit;

type
  TJCellType = (
    ctSea,
    ctShipRed, ctShipBlack, ctShipYellow, ctShipWhite,
    ctLand,
    ctEmpty1, ctEmpty2, ctEmpty3, ctEmpty4,
    ctDoubleMove,
    ctOneArrowPlain, ctOneArrowDiagonal,
    ctTwoArrowsPlain, ctTwoArrowsDiagonal,
    ctThreeArrows,
    ctFourArrowsPlain, ctFourArrowsDiagonal,
    ctTrap,
    ctMaze2Turns, ctMaze3Turns, ctMaze4Turns, ctMaze5Turns,
    ctRumBarrel, ctCrocodile, ctBalloon, ctCannon,
    ctCoinsChest1, ctCoinsChest2, ctCoinsChest3, ctCoinsChest4, ctCoinsChest5,
    ctHorse,
    ctCitadel, ctAboriginal, ctAirplane, ctCannibal
  );

  TJCellTypeInfo = class;

  //TJCell = class(TButton)
  TJCell = class(TBitBtn)
  private
    FInfo: TJCellTypeInfo;
    FDefaultGlyph: TBitmap;

    FTeam1: TList<TJUnit>;
    FTeam2: TList<TJUnit>;

    procedure DrawUnit(AUnit: TJUnit; ARow, ACol: integer);
    function SubIdxToPix(ASubIdx: integer; ADPix: integer = 0): integer;
    function PixToSubIdx(APix: integer): integer;
    function InverseSubIdx(ASubIndex: integer): integer;
    procedure SelectUnit(AX, AY: Integer);
  protected
    function Info: TJCellTypeInfo;
    function GetDefaultImageName(AInfo: TJCellTypeInfo): string; virtual;
    function GetCurrentGlyph: Graphics.TBitmap; virtual;
    function SubCellWidth: integer;
    function UnitMargin: integer;

    procedure MouseDown(
      Button: TMouseButton; Shift: TShiftState;
      X: Integer; Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    class function DefaultImageName: string; virtual; abstract;

    procedure SetInfo(AInfo: TJCellTypeInfo);
    procedure Init; virtual;
    procedure Draw; virtual;
    procedure AddUnit(AUnit: TJUnit);
  end;


  TJCellClass = class of TJCell;


  TJCellTypeInfo = class(TObject)
  private
    FCellClass: TJCellClass;
    FImageName: string;
  public
    constructor Create(ACellClass: TJCellClass; const AImageName: string);

    property CellClass: TJCellClass read FCellClass;
    property ImageName: string read FImageName;
  end;


  TJShipCell = class(TJCell)
  private
    FOwnUnits: TList<TJUnit>;

    procedure DrawUnit(AUnit: TJUnit; ARow, ACol: integer);
  protected
    class function GetPirateClass: TJPirateClass; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init; override;
    procedure Draw; override;

    procedure AddOwnUnit(AUnit: TJUnit);
  end;


  TJShipTypeInfo = class(TJCellTypeInfo)
  private
    FUnitType: TJUnitType;
  public
    constructor Create(const AImageName: string; AUnitType: TJUnitType);

    property UnitType: TJUnitType read FUnitType;
  end;


  TJShipRedCell = class(TJShipCell)
  protected
    class function GetPirateClass: TJPirateClass; override;
  public
    class function DefaultImageName: string; override;
  end;


  TJShipBlackCell = class(TJShipCell)
  protected
    class function GetPirateClass: TJPirateClass; override;
  public
    class function DefaultImageName: string; override;
  end;


  TJShipYellowCell = class(TJShipCell)
  protected
    class function GetPirateClass: TJPirateClass; override;
  public
    class function DefaultImageName: string; override;
  end;


  TJShipWhiteCell = class(TJShipCell)
  protected
    class function GetPirateClass: TJPirateClass; override;
  public
    class function DefaultImageName: string; override;
  end;


  TJLandCell = class(TJCell)
  private
    FOpenedGlyph: TBitmap;
    FOpened: boolean;
  protected
    function GetDefaultImageName(AInfo: TJCellTypeInfo): string; override;
    function GetCurrentGlyph: Graphics.TBitmap; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init; override;
    class function DefaultImageName: string; override;
    class function OpenedImageName: string; virtual;
    class function OpenedCellImageIndex: integer; virtual;

    property Opened: boolean read FOpened write FOpened;
  end;


  TJEmptyCell = class(TJLandCell)
  end;


  TJEmpty1Cell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
    class function OpenedCellImageIndex: integer; override;
  end;


  TJEmpty2Cell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
    class function OpenedCellImageIndex: integer; override;
  end;


  TJEmpty3Cell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
    class function OpenedCellImageIndex: integer; override;
  end;


  TJEmpty4Cell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
    class function OpenedCellImageIndex: integer; override;
  end;


  TJDoubleMoveCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
    class function OpenedCellImageIndex: integer; override;
  end;


  TJOneArrowPlainCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
    class function OpenedCellImageIndex: integer; override;
  end;


  TJOneArrowDiagonalCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
    class function OpenedCellImageIndex: integer; override;
  end;


  TJTwoArrowsPlainCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
    class function OpenedCellImageIndex: integer; override;
  end;


  TJTwoArrowsDiagonalCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
    class function OpenedCellImageIndex: integer; override;
  end;


  TJThreeArrowsCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
    class function OpenedCellImageIndex: integer; override;
  end;


  TJFourArrowsPlainCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
    class function OpenedCellImageIndex: integer; override;
  end;


  TJFourArrowsDiagonalCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
    class function OpenedCellImageIndex: integer; override;
  end;


  TJHorseCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
  end;


  TJTrapCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
    class function OpenedCellImageIndex: integer; override;
  end;


  TJMazeCell = class(TJLandCell)
  end;


  TJMaze2TurnsCell = class(TJMazeCell)
  public
    class function OpenedImageName: string; override;
  end;


  TJMaze3TurnsCell = class(TJMazeCell)
  public
    class function OpenedImageName: string; override;
  end;


  TJMaze4TurnsCell = class(TJMazeCell)
  public
    class function OpenedImageName: string; override;
  end;


  TJMaze5TurnsCell = class(TJMazeCell)
  public
    class function OpenedImageName: string; override;
  end;


  TJRumBarrelCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
  end;


  TJCrocodileCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
  end;


  TJBalloonCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
  end;


  TJCannonCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
  end;


  TJCoinsChestCell = class(TJLandCell)
  end;


  TJCoinsChest1Cell = class(TJCoinsChestCell)
  public
    class function OpenedImageName: string; override;
  end;


  TJCoinsChest2Cell = class(TJCoinsChestCell)
  public
    class function OpenedImageName: string; override;
  end;


  TJCoinsChest3Cell = class(TJCoinsChestCell)
  public
    class function OpenedImageName: string; override;
  end;


  TJCoinsChest4Cell = class(TJCoinsChestCell)
  public
    class function OpenedImageName: string; override;
  end;


  TJCoinsChest5Cell = class(TJCoinsChestCell)
  public
    class function OpenedImageName: string; override;
  end;


  TJCitadelCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
  end;


  TJAboriginalCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
  end;


  TJAirplaneCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
  end;


  TJCannibalCell = class(TJLandCell)
  public
    class function OpenedImageName: string; override;
  end;


var
  CellDictionary: TDictionary<TJCellType, TJCellClass>;


implementation

uses
  Windows,
  UJConsts, UJEnvironment;


const
  SUB_CELL_COUNT = 5;


{ TJCell }

procedure TJCell.AddUnit(AUnit: TJUnit);
begin
  if FTeam1.Count = 0 then
    FTeam1.Add(AUnit)
  else if FTeam1[0].TeamType = AUnit.TeamType then
    FTeam1.Add(AUnit)
  else
    FTeam2.Add(AUnit)
end;


constructor TJCell.Create(AOwner: TComponent);
begin
  inherited;
  FDefaultGlyph := Graphics.TBitmap.Create;

  FTeam1 := TObjectList<TJUnit>.Create(false);
  FTeam2 := TObjectList<TJUnit>.Create(false);
end;


destructor TJCell.Destroy;
begin
  FTeam2.Free;
  FTeam1.Free;
  FDefaultGlyph.Free;
  inherited;
end;


procedure TJCell.Draw;
var
  i: integer;
begin
  Glyph.Assign(GetCurrentGlyph);
  Glyph.Canvas.Pen.Color := clSilver;
  Glyph.Canvas.Brush.Style := bsClear;
  //Glyph.Canvas.Rectangle(1, 1, Glyph.Width - 1, Glyph.Height - 1);
  Glyph.Canvas.Rectangle(0, 0, Glyph.Width - 0, Glyph.Height - 0);

  for i := 0 to FTeam1.Count - 1 do
    DrawUnit(FTeam1[i], SUB_CELL_COUNT - 1 - i, 0);
  for i := 0 to FTeam2.Count - 1 do
    DrawUnit(FTeam2[i], SUB_CELL_COUNT - 1 - i, 1);

  Glyph.TransparentColor := -1;
end;


procedure TJCell.DrawUnit(AUnit: TJUnit; ARow, ACol: integer);
const
  PEPS = 1;
var
  canvas: TCanvas;
begin
  canvas := Glyph.Canvas;

  if AUnit.Selected then
    canvas.Pen.Color := clHighlight
  else
    canvas.Pen.Color := AUnit.Color;
  canvas.Brush.Color := AUnit.Color;
  canvas.Ellipse(
    2 + ACol * SubCellWidth + UnitMargin, 2 + ARow * SubCellWidth + UnitMargin,
    (ACol + 1) * SubCellWidth - UnitMargin,
    (ARow + 1) * SubCellWidth - UnitMargin
  );
  if AUnit.Selected then begin
    canvas.MoveTo(
      SubIdxToPix(ACol, SubCellWidth div 2) + PEPS,
      SubIdxToPix(ARow, SubCellWidth div 3) + PEPS
    );
    canvas.LineTo(
      SubIdxToPix(ACol, SubCellWidth div 2) + PEPS,
      SubIdxToPix(ARow + 1, -SubCellWidth div 3) + PEPS
    );
    canvas.MoveTo(
      SubIdxToPix(ACol, SubCellWidth div 3) + PEPS,
      SubIdxToPix(ARow, SubCellWidth div 2) + PEPS
    );
    canvas.LineTo(
      SubIdxToPix(ACol + 1, -SubCellWidth div 3) + PEPS,
      SubIdxToPix(ARow, SubCellWidth div 2) + PEPS
    );
  end;
end;


function TJCell.GetCurrentGlyph: Graphics.TBitmap;
begin
  Result := FDefaultGlyph;
end;


function TJCell.GetDefaultImageName(AInfo: TJCellTypeInfo): string;
begin
  Result := AInfo.ImageName;
end;


function TJCell.Info: TJCellTypeInfo;
begin
  Result := FInfo;
end;


procedure TJCell.Init;
begin
  FDefaultGlyph.Assign(Environment.GetRandomImage(GetDefaultImageName(Info)));
end;


function TJCell.InverseSubIdx(ASubIndex: integer): integer;
begin
  Result := SUB_CELL_COUNT - 1 - ASubIndex;
end;


procedure TJCell.MouseDown(
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  SelectUnit(X, Y);
  Draw;
end;


function TJCell.PixToSubIdx(APix: integer): integer;
begin
  Result := APix div SubCellWidth;
end;


procedure TJCell.SelectUnit(AX, AY: Integer);
var
  subCol, subRow: integer;
begin
  subCol := PixToSubIdx(AX);
  subRow := InverseSubIdx(PixToSubIdx(AY));
  if (subCol = 0) and (subRow < FTeam1.Count) then
    FTeam1[subRow].Selected := true
  else if (subCol = 1) and (subRow < FTeam2.Count) then
    FTeam2[subRow].Selected := true;
end;


procedure TJCell.SetInfo(AInfo: TJCellTypeInfo);
begin
  FInfo := AInfo;
end;


function TJCell.SubCellWidth: integer;
begin
  Result := Glyph.Width div SUB_CELL_COUNT;
end;


function TJCell.SubIdxToPix(ASubIdx, ADPix: integer): integer;
begin
  Result := ASubIdx * SubCellWidth + ADPix;
end;


function TJCell.UnitMargin: integer;
const
  UNIT_MARGIN_PART = 8;
begin
  Result := SubCellWidth div UNIT_MARGIN_PART;
end;


class function TJShipRedCell.DefaultImageName: string;
begin
  Result := 'imgShipRed';
end;


class function TJShipRedCell.GetPirateClass: TJPirateClass;
begin
  Result := TJPirateRed;
end;


class function TJShipBlackCell.DefaultImageName: string;
begin
  Result := 'imgShipBlack';
end;


class function TJShipBlackCell.GetPirateClass: TJPirateClass;
begin
  Result := TJPirateBlack;
end;


class function TJShipYellowCell.DefaultImageName: string;
begin
  Result := 'imgShipYellow';
end;


class function TJShipYellowCell.GetPirateClass: TJPirateClass;
begin
  Result := TJPirateYellow;
end;


class function TJShipWhiteCell.DefaultImageName: string;
begin
  Result := 'imgShipWhite';
end;


class function TJShipWhiteCell.GetPirateClass: TJPirateClass;
begin
  Result := TJPirateWhite;
end;


{ TJLandCell }

constructor TJLandCell.Create(AOwner: TComponent);
begin
  inherited;
  FOpenedGlyph := Graphics.TBitmap.Create;
end;


class function TJLandCell.DefaultImageName: string;
begin
  Result := 'imgLand';
end;


destructor TJLandCell.Destroy;
begin
  FOpenedGlyph.Free;
  inherited;
end;


function TJLandCell.GetCurrentGlyph: Graphics.TBitmap;
begin
  if FOpened then
    Result := FOpenedGlyph
  else
    Result := inherited GetCurrentGlyph;
end;


function TJLandCell.GetDefaultImageName(AInfo: TJCellTypeInfo): string;
begin
  Result := 'imgLand';
end;


procedure TJLandCell.Init;
begin
  inherited;
  FOpenedGlyph.Assign(Environment.GetRandomImage(Info.ImageName));
end;


class function TJLandCell.OpenedCellImageIndex: integer;
begin
  Result := CELL_IMG_IDX_LAND;
end;


class function TJLandCell.OpenedImageName: string;
begin
  Result := DefaultImageName;
end;


{ TJEmpty1Cell }

class function TJEmpty1Cell.OpenedCellImageIndex: integer;
begin
  Result := CELL_IMG_IDX_EMPTY1;
end;


class function TJEmpty1Cell.OpenedImageName: string;
begin
  Result := 'imgEmpty1';
end;


{ TJEmpty2Cell }

class function TJEmpty2Cell.OpenedCellImageIndex: integer;
begin
  Result := CELL_IMG_IDX_EMPTY2;
end;


class function TJEmpty2Cell.OpenedImageName: string;
begin
  Result := 'imgEmpty2';
end;


{ TJEmpty3Cell }

class function TJEmpty3Cell.OpenedCellImageIndex: integer;
begin
  Result := CELL_IMG_IDX_EMPTY3;
end;


class function TJEmpty3Cell.OpenedImageName: string;
begin
  Result := 'imgEmpty3';
end;


{ TJEmpty4Cell }

class function TJEmpty4Cell.OpenedCellImageIndex: integer;
begin
  Result := CELL_IMG_IDX_EMPTY4;
end;


class function TJEmpty4Cell.OpenedImageName: string;
begin
  Result := 'imgEmpty4';
end;

{ TJDoubleMoveCell }

class function TJDoubleMoveCell.OpenedCellImageIndex: integer;
begin
  Result := CELL_IMG_IDX_DOUBLE_MOVE;
end;


class function TJDoubleMoveCell.OpenedImageName: string;
begin
  Result := 'imgDoubleMove';
end;


{ TJOneArrowPlainCell }

class function TJOneArrowPlainCell.OpenedCellImageIndex: integer;
begin
  Result := CELL_IMG_IDX_ONE_ARROW_PLAIN;
end;


class function TJOneArrowPlainCell.OpenedImageName: string;
begin
  Result := 'imgOneArrowPlain';
end;


{ TJOneArrowDiagonalCell }

class function TJOneArrowDiagonalCell.OpenedCellImageIndex: integer;
begin
  Result := CELL_IMG_IDX_ONE_ARROW_DIAGONAL;
end;


class function TJOneArrowDiagonalCell.OpenedImageName: string;
begin
  Result := 'imgOneArrowDiagonal';
end;


{ TJTwoArrowsPlainCell }

class function TJTwoArrowsPlainCell.OpenedCellImageIndex: integer;
begin
  Result := CELL_IMG_IDX_TWO_ARROWS_PLAIN;
end;


class function TJTwoArrowsPlainCell.OpenedImageName: string;
begin
  Result := 'imgTwoArrowsPlain';
end;


{ TJTwoArrowsDiagonalCell }

class function TJTwoArrowsDiagonalCell.OpenedCellImageIndex: integer;
begin
  Result := CELL_IMG_IDX_TWO_ARROWS_DIAGONAL;
end;


class function TJTwoArrowsDiagonalCell.OpenedImageName: string;
begin
  Result := 'imgTwoArrowsDiagonal';
end;


{ TJThreeArrowsCell }

class function TJThreeArrowsCell.OpenedCellImageIndex: integer;
begin
  Result := CELL_IMG_IDX_THREE_ARROWS;
end;


class function TJThreeArrowsCell.OpenedImageName: string;
begin
  Result := 'imgThreeArrows';
end;


{ TJFourArrowsPlainCell }

class function TJFourArrowsPlainCell.OpenedCellImageIndex: integer;
begin
  Result := CELL_IMG_IDX_FOUR_ARROWS_PLAIN;
end;


class function TJFourArrowsPlainCell.OpenedImageName: string;
begin
  Result := 'imgFourArrowsPlain';
end;


{ TJFourArrowsDiagonalCell }

class function TJFourArrowsDiagonalCell.OpenedCellImageIndex: integer;
begin
  Result := CELL_IMG_IDX_FOUR_ARROWS_DIAGONAL;
end;


class function TJFourArrowsDiagonalCell.OpenedImageName: string;
begin
  Result := 'imgFourArrowsDiagonal';
end;


{ TJTrapCell }

class function TJTrapCell.OpenedCellImageIndex: integer;
begin
  Result := CELL_IMG_IDX_TRAP;
end;


class function TJTrapCell.OpenedImageName: string;
begin
  Result := 'imgTrap';
end;


{ TJShipCell }

procedure TJShipCell.AddOwnUnit(AUnit: TJUnit);
begin
  FOwnUnits.Add(AUnit);
end;


constructor TJShipCell.Create(AOwner: TComponent);
const
  PIRATE_COUNT = 3;
var
  i: integer;
begin
  inherited;
  FOwnUnits := TObjectList<TJUnit>.Create(false);
//  for i := 0 to PIRATE_COUNT - 1 do
//    FOwnUnits.Add(GetPirateClass.Create);
end;


destructor TJShipCell.Destroy;
begin
  FOwnUnits.Free;
  inherited;
end;


procedure TJShipCell.Draw;
var
  i: integer;
begin
  inherited;
  for i := 0 to FOwnUnits.Count - 1 do
    DrawUnit(FOwnUnits[i], SUB_CELL_COUNT - 1 - i, 0);
//  for i := 0 to 5 - 1 do
//    DrawUnit(FOwnUnits[0], SUB_CELL_COUNT - 1, i);
//  Glyph.Canvas.Pen.Color := clRed;
//  Glyph.Canvas.Ellipse(10, 10, Glyph.Width - 10, Glyph.Height - 10);
end;


procedure TJShipCell.DrawUnit(AUnit: TJUnit; ARow, ACol: integer);
begin
  Glyph.Canvas.Pen.Color := AUnit.Color;
  Glyph.Canvas.Brush.Color := AUnit.Color;
  Glyph.Canvas.Ellipse(
    2 + ACol * SubCellWidth + UnitMargin, 2 + ARow * SubCellWidth + UnitMargin,
    (ACol + 1) * SubCellWidth - UnitMargin,
    (ARow + 1) * SubCellWidth - UnitMargin
  );
end;


procedure TJShipCell.Init;
const
  PIRATE_COUNT = 3;
var
  unitType: TJUnitType;
  i: integer;
begin
  inherited;
  unitType := (Info as TJShipTypeInfo).UnitType;
  for i := 0 to PIRATE_COUNT - 1 do
    AddUnit(Environment.CreateUnit(unitType));
end;


{ TJMaze2TurnsCell }

class function TJMaze2TurnsCell.OpenedImageName: string;
begin
  Result := 'imgMaze2Turns';
end;


{ TJMaze3TurnsCell }

class function TJMaze3TurnsCell.OpenedImageName: string;
begin
  Result := 'imgMaze3Turns';
end;


{ TJMaze4TurnsCell }

class function TJMaze4TurnsCell.OpenedImageName: string;
begin
  Result := 'imgMaze4Turns';
end;


{ TJMaze5TurnsCell }

class function TJMaze5TurnsCell.OpenedImageName: string;
begin
  Result := 'imgMaze5Turns';
end;


{ TJRumBarrelCell }

class function TJRumBarrelCell.OpenedImageName: string;
begin
  Result := 'imgRumBarrel';
end;


{ TJCrocodileCell }

class function TJCrocodileCell.OpenedImageName: string;
begin
  Result := 'imgCrocodile';
end;


{ TJBalloonCell }

class function TJBalloonCell.OpenedImageName: string;
begin
  Result := 'imgBalloon';
end;


{ TJCannonCell }

class function TJCannonCell.OpenedImageName: string;
begin
  Result := 'imgCannon';
end;


{ TJCoinsChest1Cell }

class function TJCoinsChest1Cell.OpenedImageName: string;
begin
  Result := 'imgCoinsChest1';
end;


{ TJCoinsChest2Cell }

class function TJCoinsChest2Cell.OpenedImageName: string;
begin
  Result := 'imgCoinsChest2';
end;


{ TJCoinsChest3Cell }

class function TJCoinsChest3Cell.OpenedImageName: string;
begin
  Result := 'imgCoinsChest3';
end;


{ TJCoinsChest4Cell }

class function TJCoinsChest4Cell.OpenedImageName: string;
begin
  Result := 'imgCoinsChest4';
end;


{ TJCoinsChest5Cell }

class function TJCoinsChest5Cell.OpenedImageName: string;
begin
  Result := 'imgCoinsChest5';
end;


{ TJHorseCell }

class function TJHorseCell.OpenedImageName: string;
begin
  Result := 'imgHorse';
end;


{ TJCitadelCell }

class function TJCitadelCell.OpenedImageName: string;
begin
  Result := 'imgCitadel';
end;


{ TJAborigenalCell }

class function TJAboriginalCell.OpenedImageName: string;
begin
  Result := 'imgAboriginal';
end;


{ TJAirplaneCell }

class function TJAirplaneCell.OpenedImageName: string;
begin
  Result := 'imgAirplane';
end;


{ TJCannibalCell }

class function TJCannibalCell.OpenedImageName: string;
begin
  Result := 'imgCannibal';
end;


{ TJCellTypeInfo }

constructor TJCellTypeInfo.Create(
  ACellClass: TJCellClass; const AImageName: string);
begin
  inherited Create;
  FCellClass := ACellClass;
  FImageName := AImageName;
end;


{ TJShipTypeInfo }

constructor TJShipTypeInfo.Create(
  const AImageName: string; AUnitType: TJUnitType);
begin
  inherited Create(TJShipCell, AImageName);
  FUnitType := AUnitType;
end;


initialization
  CellDictionary := TDictionary<TJCellType, TJCellClass>.Create;

  CellDictionary.Add(ctShipRed, TJShipRedCell);
  CellDictionary.Add(ctShipBlack, TJShipBlackCell);
  CellDictionary.Add(ctShipYellow, TJShipYellowCell);
  CellDictionary.Add(ctShipWhite, TJShipWhiteCell);
  CellDictionary.Add(ctLand, TJLandCell);
  CellDictionary.Add(ctEmpty1, TJEmpty1Cell);
  CellDictionary.Add(ctEmpty2, TJEmpty2Cell);
  CellDictionary.Add(ctEmpty3, TJEmpty3Cell);
  CellDictionary.Add(ctEmpty4, TJEmpty4Cell);
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


finalization
  CellDictionary.Free;


end.
