unit UJCellBitmapContainer;

interface

uses
  Generics.Collections, Graphics,
  krn_Containers,
  UJCell;


type
  TJBitmapDictionary = TObjectDictionary<integer, TBitmap>;

  TJCellBitmapContainer = class(TObject)
  private
    //FCache: TObjectDictionary<string{TJCellType}, TJBitmapDictionary>;
    FCache: TStringObjectDictionary<TJBitmapDictionary>;
  public
    constructor Create;
    destructor Destroy; override;

//    function TryGetBitmap(
//      ACellType: TJCellType; AKey: integer; out AResult: TBitmap): boolean;
//    function EnsureBitmapDictionary(ACellType: TJCellType): TJBitmapDictionary;
    function TryGetBitmap(
      const AImageName: string; AKey: integer; out AResult: TBitmap): boolean;
    function EnsureBitmapDictionary(
      const AImageName: string): TJBitmapDictionary;
  end;


implementation

{ TJCellBitmapContainer }

constructor TJCellBitmapContainer.Create;
begin
  inherited Create;
//  FCache :=
//    TObjectDictionary<string{TJCellType}, TJBitmapDictionary>.Create([doOwnsValues]);
  FCache :=
    TStringObjectDictionary<TJBitmapDictionary>.Create([doOwnsValues], false);
end;


destructor TJCellBitmapContainer.Destroy;
begin
  FCache.Free;
  inherited;
end;


function TJCellBitmapContainer.EnsureBitmapDictionary(
  const AImageName: string): TJBitmapDictionary;
begin
  if not FCache.TryGetValue(AImageName, Result) then begin
    Result := TJBitmapDictionary.Create([doOwnsValues]);
    FCache.Add(AImageName, Result);
  end;
end;


function TJCellBitmapContainer.TryGetBitmap(
  const AImageName: string; AKey: integer; out AResult: TBitmap): boolean;
var
  bitmapDict: TJBitmapDictionary;
begin
  Result :=
    FCache.TryGetValue(AImageName, bitmapDict) and
    bitmapDict.TryGetValue(AKey, AResult);
end;

{
function TJCellBitmapContainer.EnsureBitmapDictionary(
  ACellType: TJCellType): TJBitmapDictionary;
begin
  if not FCache.TryGetValue(ACellType, Result) then begin
    Result := TJBitmapDictionary.Create([doOwnsValues]);
    FCache.Add(ACellType, Result);
  end;
end;


function TJCellBitmapContainer.TryGetBitmap(
  ACellType: TJCellType; AKey: integer; out AResult: TBitmap): boolean;
var
  bitmapDict: TJBitmapDictionary;
begin
  Result :=
    FCache.TryGetValue(ACellType, bitmapDict) and
    bitmapDict.TryGetValue(AKey, AResult);
end;
}

end.
