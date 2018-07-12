unit UJCellMatrix;

interface

uses
  Controls, Classes, StdCtrls, Generics.Collections, Graphics,
  UCellMatrix, UJCell, UJCellBitmapContainer, UJUnit;

const
  ORIENT_COUNT = 4;
  //MAP_LENGTH = 13;
  MAP_LENGTH = 5;


type
  TJCellMatrix = class(TCellMatrix)
  private
    FMap:
      array [0 .. MAP_LENGTH - 1] of array [0 .. MAP_LENGTH - 1] of TJCellType;
    FRemainCellTypes: TList<TJCellType>;
    FUnitsContainer: TObjectList<TJUnit>;

    procedure CancelButtonBlinking(AButton: TButton);

    function RandomCellType: TJCellType;
    procedure BuildRemainCellTypes;
    procedure FillMap;
    procedure CellClick(Sender: TObject);

    procedure BlockMouseDown(
      Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BlockMouseUp(
      Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BlockMouseMove(
      Sender: TObject; Shift: TShiftState; X, Y: Integer);
  protected
    function GetCellClass(ARow, ACol: integer): TControlClass; override;
    procedure InitCell(ACell: TControl; ARow, ACol: integer); override;
  public
    constructor Create(
      AContainer: TWinControl; ACellImages: TImageList; ACellWidth: integer);
    destructor Destroy; override;
  end;

implementation

uses
  ExtCtrls, Types, CommCtrl, Math, Windows,
  UUtils, UJVDM, UJEnvironment, UJRegister;

const
{  INIT_MAP:
    array [0 .. MAP_LENGTH - 1] of array [0 .. MAP_LENGTH - 1] of TJCellType =
  (
    (ctSea,     ctSea,  ctSea,  ctSea,  ctSea,  ctSea,  ctShipWhite, ctSea,  ctSea,  ctSea,  ctSea,  ctSea,  ctSea),
    (ctSea,     ctSea,  ctLand, ctLand, ctLand, ctLand, ctLand,      ctLand, ctLand, ctLand, ctLand, ctSea,  ctSea),
    (ctSea,     ctLand, ctLand, ctLand, ctLand, ctLand, ctLand,      ctLand, ctLand, ctLand, ctLand, ctLand, ctSea),
    (ctSea,     ctLand, ctLand, ctLand, ctLand, ctLand, ctLand,      ctLand, ctLand, ctLand, ctLand, ctLand, ctSea),
    (ctSea,     ctLand, ctLand, ctLand, ctLand, ctLand, ctLand,      ctLand, ctLand, ctLand, ctLand, ctLand, ctSea),
    (ctSea,     ctLand, ctLand, ctLand, ctLand, ctLand, ctLand,      ctLand, ctLand, ctLand, ctLand, ctLand, ctSea),
    (ctShipRed, ctLand, ctLand, ctLand, ctLand, ctLand, ctLand,      ctLand, ctLand, ctLand, ctLand, ctLand, ctShipYellow),
    (ctSea,     ctLand, ctLand, ctLand, ctLand, ctLand, ctLand,      ctLand, ctLand, ctLand, ctLand, ctLand, ctSea),
    (ctSea,     ctLand, ctLand, ctLand, ctLand, ctLand, ctLand,      ctLand, ctLand, ctLand, ctLand, ctLand, ctSea),
    (ctSea,     ctLand, ctLand, ctLand, ctLand, ctLand, ctLand,      ctLand, ctLand, ctLand, ctLand, ctLand, ctSea),
    (ctSea,     ctLand, ctLand, ctLand, ctLand, ctLand, ctLand,      ctLand, ctLand, ctLand, ctLand, ctLand, ctSea),
    (ctSea,     ctSea,  ctLand, ctLand, ctLand, ctLand, ctLand,      ctLand, ctLand, ctLand, ctLand, ctSea,  ctSea),
    (ctSea,     ctSea,  ctSea,  ctSea,  ctSea,  ctSea,  ctShipBlack, ctSea,  ctSea,  ctSea,  ctSea,  ctSea,  ctSea)
  );
}
  INIT_MAP:
    array [0 .. MAP_LENGTH - 1] of array [0 .. MAP_LENGTH - 1] of TJCellType =
  (
    (ctSea,     ctSea,  ctShipWhite, ctSea,  ctSea),
    (ctSea,     ctLand, ctLand,      ctLand, ctSea),
    (ctShipRed, ctLand, ctLand,      ctLand, ctShipYellow),
    (ctSea,     ctLand, ctLand,      ctLand, ctSea),
    (ctSea,     ctSea,  ctShipBlack, ctSea,  ctSea)
  );

{  CELLS_SET_LENGTH = 48;
  CELLS_SET: array [0 .. CELLS_SET_LENGTH - 1] of TJCellType = (
    ctEmpty1, ctEmpty1, ctEmpty1, ctEmpty1, ctEmpty1,
    ctEmpty2, ctEmpty2, ctEmpty2, ctEmpty2, ctEmpty2,
    ctEmpty3, ctEmpty3, ctEmpty3, ctEmpty3,
    ctEmpty4, ctEmpty4, ctEmpty4, ctEmpty4,
    ctDoubleMove, ctDoubleMove, ctDoubleMove, ctDoubleMove, ctDoubleMove, ctDoubleMove,
    ctOneArrowPlain, ctOneArrowPlain, ctOneArrowPlain,
    ctOneArrowDiagonal, ctOneArrowDiagonal, ctOneArrowDiagonal,
    ctTwoArrowsPlain, ctTwoArrowsPlain, ctTwoArrowsPlain,
    ctTwoArrowsDiagonal, ctTwoArrowsDiagonal, ctTwoArrowsDiagonal,
    ctThreeArrows, ctThreeArrows, ctThreeArrows,
    ctFourArrowsPlain, ctFourArrowsPlain, ctFourArrowsPlain,
    ctFourArrowsDiagonal, ctFourArrowsDiagonal, ctFourArrowsDiagonal,
    ctTrap, ctTrap, ctTrap
  );
}
  CELLS_SET_LENGTH = 1;//31;
  CELLS_SET: array [0 .. CELLS_SET_LENGTH - 1] of record
    CellType: TJCellType;
    Count: integer;
  end = (
    (CellType: ctEmpty1; Count: 5 + 220));{,
    (CellType: ctEmpty2; Count: 5),
    (CellType: ctEmpty3; Count: 4),
    (CellType: ctEmpty4; Count: 4),
    (CellType: ctDoubleMove; Count: 6),
    (CellType: ctOneArrowPlain; Count: 3),
    (CellType: ctOneArrowDiagonal; Count: 3),
    (CellType: ctTwoArrowsPlain; Count: 3),
    (CellType: ctTwoArrowsDiagonal; Count: 3),
    (CellType: ctThreeArrows; Count: 3),
    (CellType: ctFourArrowsPlain; Count: 3),
    (CellType: ctFourArrowsDiagonal; Count: 3),
    (CellType: ctTrap; Count: 3),
    (CellType: ctMaze2Turns; Count: 5),
    (CellType: ctMaze3Turns; Count: 4),
    (CellType: ctMaze4Turns; Count: 2),
    (CellType: ctMaze5Turns; Count: 1),
    (CellType: ctRumBarrel; Count: 4),
    (CellType: ctCrocodile; Count: 4),
    (CellType: ctBalloon; Count: 2),
    (CellType: ctCannon; Count: 2),
    (CellType: ctCoinsChest1; Count: 5),
    (CellType: ctCoinsChest2; Count: 5),
    (CellType: ctCoinsChest3; Count: 3),
    (CellType: ctCoinsChest4; Count: 2),
    (CellType: ctCoinsChest5; Count: 1),
    (CellType: ctHorse; Count: 2),
    (CellType: ctCitadel; Count: 2),
    (CellType: ctAboriginal; Count: 1),
    (CellType: ctAirplane; Count: 1),
    (CellType: ctCannibal; Count: 1)
  );}


  { TJCellMatrix }

procedure TJCellMatrix.BlockMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;


procedure TJCellMatrix.BlockMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;


procedure TJCellMatrix.BlockMouseUp(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;


procedure TJCellMatrix.BuildRemainCellTypes;
var
  i, j: integer;
begin
  for i := Low(CELLS_SET) to High(CELLS_SET) do
    for j := 0 to CELLS_SET[i].Count - 1 do
      FRemainCellTypes.Add(CELLS_SET[i].CellType);
end;


procedure TJCellMatrix.CancelButtonBlinking(AButton: TButton);
var
  ButtonImageList: TButtonImageList;
  Icon: HICON;
begin
  SendMessage(AButton.Handle, BCM_GETIMAGELIST, 0, LPARAM(@ButtonImageList));
  Icon := ImageList_GetIcon(ButtonImageList.himl, 0, ILD_NORMAL);
  ImageList_AddIcon(ButtonImageLIst.himl, Icon);
  DestroyIcon(Icon);
end;


procedure TJCellMatrix.CellClick(Sender: TObject);
var
  landCell: TJLandCell;
begin
  if Sender is TJLandCell then begin
    landCell := Sender as TJLandCell;
    landCell.Opened := true;
    landCell.Draw;
//    landCell.Images := FCellImages[Random(ORIENT_COUNT)];
//    landCell.ImageIndex := landCell.OpenedCellImageIndex;
  end;
end;


constructor TJCellMatrix.Create(
  AContainer: TWinControl; ACellImages: TImageList; ACellWidth: integer);
var
  cnrLen: integer;
  calcCellWidth: integer;
begin
  cnrLen := Min(AContainer.Height, AContainer.Width);
  calcCellWidth := cnrLen div MAP_LENGTH;
  inherited Create(AContainer, calcCellWidth, MAP_LENGTH, MAP_LENGTH);

  Randomize;
  Environment.CellWidth := calcCellWidth;
  FRemainCellTypes := TList<TJCellType>.Create;
  BuildRemainCellTypes;
  FillMap;

  FUnitsContainer := TObjectList<TJUnit>.Create(true);
end;


destructor TJCellMatrix.Destroy;
begin
  FUnitsContainer.Free;
  FRemainCellTypes.Free;
  inherited;
end;


procedure TJCellMatrix.FillMap;
var
  i, j: integer;
  cellType: TJCellType;
begin
  for i := 0 to MAP_LENGTH - 1 do
    for j := 0 to MAP_LENGTH - 1 do begin
      cellType := INIT_MAP[i, j];
      if cellType = ctLand then
        FMap[i, j] := RandomCellType
      else
        FMap[i, j] := cellType;
    end;
end;


function TJCellMatrix.GetCellClass(ARow, ACol: integer): TControlClass;
var
  cellType: TJCellType;
  cellClass: TJCellClass;
begin
  cellType := FMap[ARow, ACol];
  if cellType = ctSea then
    Result := inherited GetCellClass(ARow, ACol)
  else if CellRegistry.TryGetCellClass(FMap[ARow, ACol], cellClass) then
    Result := cellClass
  else if CellRegistry.TryGetCellClass(ctLand, cellClass) then
    Result := cellClass
  else
    Result := inherited GetCellClass(ARow, ACol);
end;


procedure TJCellMatrix.InitCell(ACell: TControl; ARow, ACol: integer);
var
  cell: TJCell;
  cellType: TJCellType;
  cellInfo: TJCellTypeInfo;
  landCell: TJLandCell;
begin
  inherited;
  if ACell is TJCell then
  begin
    cell := ACell as TJCell;
    cellType := FMap[ARow, ACol];
    if CellRegistry.TryGetCellInfo(cellType, cellInfo) then
      cell.SetInfo(cellInfo)
    else if CellRegistry.TryGetCellInfo(ctLand, cellInfo) then
      cell.SetInfo(cellInfo);
    cell.Init;

//    if cellType in [ctShipRed, ctShipBlack, ctShipYellow, ctShipWhite] then
//      cell.AddUnit();
    cellType := INIT_MAP[ARow, ACol];
    case cellType of
      ctLand:
        begin
          cell.OnClick := CellClick;
        end;
    end;
    cell.Draw;
    //CancelButtonBlinking(cell);
//    cell.OnMouseDown := BlockMouseDown;
//    cell.OnMouseUp := BlockMouseUp;
//    cell.OnMouseMove := BlockMouseMove;
  end;
end;


function TJCellMatrix.RandomCellType: TJCellType;
var
  idx: integer;
begin
  if FRemainCellTypes.Count > 0 then begin
    idx := Random(FRemainCellTypes.Count);
    Result := FRemainCellTypes[idx];
    FRemainCellTypes.Delete(idx);
  end
  else
    Result := ctLand;
end;


end.
