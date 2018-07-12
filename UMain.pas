unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ExtCtrls,
  UJCellMatrix, Buttons;

type
  TfrmMain = class(TForm)
    ilCells: TImageList;
    pnMap: TPanel;
    Button1: TButton;
    btnExp: TBitBtn;
    btnExp2: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FCellMatrix: TJCellMatrix;
    function GetDesktopSize: TSize;
    procedure StretchOnScreen;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  Math, Types;

type
  TCellType = (ctSea, ctShip, ctLand);


const
  CELL_WIDTH = 80;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  inherited;
//  ilCells.Height := CELL_WIDTH - 4;
//  ilCells.Width := CELL_WIDTH - 4;
  StretchOnScreen;
  FCellMatrix := TJCellMatrix.Create(pnMap, ilCells, CELL_WIDTH);
  ClientHeight := FCellMatrix.Width;
  ClientWidth := FCellMatrix.Width;
end;


procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FCellMatrix.Free;
  inherited;
end;


function TfrmMain.GetDesktopSize: TSize;
var
  r: TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @r, 0);
  Result.cx := r.Right - r.Left;
  Result.cy := r.Bottom - r.Top;
end;


procedure TfrmMain.StretchOnScreen;
var
  fLen: integer;
  dtSize: TSize;
begin
//  Self.WindowState := wsMaximized;
//  fLen := Min(Screen.Width, Screen.Height);
  dtSize := GetDesktopSize;
  fLen := Min(dtSize.cx, dtSize.cy);
  Width := fLen;
  Height := fLen;
  Left := (dtSize.cx - fLen) div 2;
  Top := (dtSize.cy - fLen) div 2;
end;


end.
