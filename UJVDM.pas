unit UJVDM;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,
  krn_Containers;

type
  TJVDM = class(TForm)
    imgShipRed: TImage;
    imgShipBlack: TImage;
    imgShipYellow: TImage;
    imgShipWhite: TImage;
    imgLand: TImage;
    imgEmpty1: TImage;
    imgEmpty2: TImage;
    imgEmpty3: TImage;
    imgEmpty4: TImage;
    imgDoubleMove: TImage;
    imgOneArrowPlain: TImage;
    imgOneArrowDiagonal: TImage;
    imgTwoArrowsPlain: TImage;
    imgTwoArrowsDiagonal: TImage;
    imgThreeArrows: TImage;
    imgFourArrowsPlain: TImage;
    imgFourArrowsDiagonal: TImage;
    imgTrap: TImage;
    imgMaze2Turns: TImage;
    imgMaze3Turns: TImage;
    imgMaze4Turns: TImage;
    imgMaze5Turns: TImage;
    imgRumBarrel: TImage;
    imgCrocodile: TImage;
    imgBalloon: TImage;
    imgCannon: TImage;
    imgHorse: TImage;
    imgCitadel: TImage;
    imgCoinsChest1: TImage;
    imgCoinsChest2: TImage;
    imgCoinsChest3: TImage;
    imgCoinsChest4: TImage;
    imgCoinsChest5: TImage;
    imgAboriginal: TImage;
    imgAirplane: TImage;
    imgCannibal: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FImagesMap: TStringObjectDictionary<TBitmap>;

    procedure FillImagesMap;
  public
    { Public declarations }
    function ImageByName(const AImageName: string): TBitmap;
  end;

var
  JVDM: TJVDM;

implementation

{$R *.dfm}

{ TJVDM }

procedure TJVDM.FillImagesMap;
var
  i: integer;
  control: TControl;
begin
  for i := 0 to ControlCount - 1 do begin
    control := Controls[i];
    if control is TImage then
      FImagesMap.Add(control.Name, (control as TImage).Picture.Bitmap);
  end;
end;


procedure TJVDM.FormCreate(Sender: TObject);
begin
  inherited;
  FImagesMap := TStringObjectDictionary<TBitmap>.Create([], false);
  FillImagesMap;
end;


procedure TJVDM.FormDestroy(Sender: TObject);
begin
  FImagesMap.Free;
  inherited;
end;


function TJVDM.ImageByName(const AImageName: string): TBitmap;
begin
  if not FImagesMap.TryGetValue(AImageName, Result) then
    raise Exception.CreateFmt('Image "%s" not found in JVDM', [AImageName]);
end;


initialization
  JVDM := TJVDM.Create(nil);


finalization
  JVDM.Free;


end.
