unit UJEnvironment;

interface

uses
  Graphics, Generics.Collections,
  UJCellBitmapContainer, UJUnit;

type
  TJEnvironment = class(TObject)
  private
    FBitmapCache: TJCellBitmapContainer;
    FUnitsContainer: TObjectList<TJUnit>;
    FCellWidth: integer;

    function ImageWidth: integer;
    function CopyJVDMBitmap(
      const AImageName: string; AOrientation: integer): TBitmap;
  public
    constructor Create;
    destructor Destroy; override;

    function GetRandomImage(const AImageName: string): TBitmap;

    function CreateUnit(AUnitType: TJUnitType): TJUnit;

    property CellWidth: integer read FCellWidth write FCellWidth;
  end;


var
  Environment: TJEnvironment;


implementation

uses
  Types,
  UJVDM, UUtils, UJRegister;


{ TJEnvironment }

function TJEnvironment.CopyJVDMBitmap(
  const AImageName: string; AOrientation: integer): TBitmap;
var
  origImg: Graphics.TBitmap;
  rct: TRect;
  srcRotated: Graphics.TBitmap;
begin
  origImg := JVDM.ImageByName(AImageName);
  rct := Rect(0, 0, ImageWidth, ImageWidth);

  Result := Graphics.TBitmap.Create;
  Result.Height := ImageWidth;
  Result.Width := ImageWidth;
  Result.Canvas.FillRect(rct);
  if AOrientation = 0 then
    Result.Canvas.StretchDraw(rct, origImg)
  else begin
    Result.PixelFormat := pf24bit;
    srcRotated := nil;
    case AOrientation of
      1: srcRotated := RotateBitmap90(origImg);
      2: srcRotated := RotateBitmap180(origImg);
      3: srcRotated := RotateBitmap270(origImg);
    end;
    try
      Result.Canvas.StretchDraw(rct, srcRotated);
    finally
      srcRotated.Free;
    end;
  end;
end;


constructor TJEnvironment.Create;
begin
  inherited Create;
  FBitmapCache := TJCellBitmapContainer.Create;
  FUnitsContainer := TObjectList<TJUnit>.Create(true);
end;


function TJEnvironment.CreateUnit(AUnitType: TJUnitType): TJUnit;
var
  unitInfo: TJUnitTypeInfo;
begin
  unitInfo := UnitRegistry[AUnitType];
  Result := TJUnit.Create(unitInfo.TeamType, unitInfo.Color);
  FUnitsContainer.Add(Result);
end;


destructor TJEnvironment.Destroy;
begin
  FUnitsContainer.Free;
  FBitmapCache.Free;
  inherited;
end;


function TJEnvironment.GetRandomImage(const AImageName: string): TBitmap;
const
  ORIENT_COUNT = 4;
var
  orient: integer;
  bitmapDict: TJBitmapDictionary;
begin
  orient := Random(ORIENT_COUNT);
  bitmapDict := FBitmapCache.EnsureBitmapDictionary(AImageName);
  if
    (bitmapDict.Count = 0) or not bitmapDict.TryGetValue(orient, Result)
  then begin
    Result := CopyJVDMBitmap(AImageName, orient);
    bitmapDict.Add(orient, Result);
  end;
end;


function TJEnvironment.ImageWidth: integer;
begin
  Result := CellWidth + 1;
end;


initialization
  Environment := TJEnvironment.Create;


finalization
  Environment.Free;


end.
