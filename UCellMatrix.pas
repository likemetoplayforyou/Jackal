unit UCellMatrix;

interface

uses
  Controls;

type
  TCellMatrix = class(TObject)
  private
    FContainer: TWinControl;
    FCellWidth: integer;
    FRowCount: integer;
    FColCount: integer;

    function CreateCell(ARow, ACol: integer): TControl;

    procedure Log(const AMsg: string; const AArgs: array of const);
  protected
    function GetCellClass(ARow, ACol: integer): TControlClass; virtual;
    procedure InitCell(ACell: TControl; ARow, ACol: integer); virtual;
  public
    constructor Create(
      AContainer: TWinControl; ACellWidth, ARows, ACols: integer);
    procedure AfterConstruction; override;

    function Width: integer;
    property Container: TWinControl read FContainer;
    property CellWidth: integer read FCellWidth;
  end;


implementation

{ TCellMatrix }

procedure TCellMatrix.AfterConstruction;
var
  i, j: integer;
  cell: TControl;
begin
  inherited;
  for i := 0 to FRowCount - 1 do begin
    for j := 0 to FColCount - 1 do begin
      cell := CreateCell(i, j);
//      if cell <> nil then
//        InitCell(cell, i, j);
    end;
  end;
end;


constructor TCellMatrix.Create(
  AContainer: TWinControl; ACellWidth, ARows, ACols: integer);
begin
  inherited Create;
  FContainer := AContainer;
  FCellWidth := ACellWidth;
  FColCount := ACols;
  FRowCount := ARows;
end;


function TCellMatrix.CreateCell(ARow, ACol: integer): TControl;
var
  cellClass: TControlClass;
begin
  Result := nil;
  cellClass := GetCellClass(ARow, ACol);
  if cellClass = nil then
    Exit;

  Result := cellClass.Create(FContainer);
  try
    InitCell(Result, ARow, ACol);
  except
    Result.Free;
    raise;
  end;
end;


function TCellMatrix.GetCellClass(ARow, ACol: integer): TControlClass;
begin
  Result := nil;
end;


procedure TCellMatrix.InitCell(ACell: TControl; ARow, ACol: integer);
begin
  ACell.Parent := FContainer;
  ACell.Width := FCellWidth;
  ACell.Height := FCellWidth;
  ACell.Left := ACol * FCellWidth;
  ACell.Top := ARow * FCellWidth;
end;


procedure TCellMatrix.Log(const AMsg: string; const AArgs: array of const);
begin

end;


function TCellMatrix.Width: integer;
begin
  Result := FColCount * FCellWidth;
end;


end.
