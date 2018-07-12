unit krn_Containers;

interface

uses
  Classes, Generics.Collections;
  //,UBHashTable;

type
{  THashedStringList = class(TObject)
  private
    FHash: IBHashTable;
    FList: TStringList;

    function Get(AIndex: integer): string;
    procedure Put(AIndex: integer; const AValue: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(const AStr: string);
    procedure Delete(AIndex: integer);
    function Count: integer;
    function GetEnumerator: TStringsEnumerator;

    property Strings[AIndex: integer]: string read Get write Put; default;
  end;
 }

  TSet<T> = class(TEnumerable<T>)
  private
    FItems: TDictionary<T, boolean>;
  protected
    function DoGetEnumerator: TEnumerator<T>; override;
  public
    constructor Create;
    destructor Destroy; override;

    function Count: integer;
    function Has(const AItem: T): boolean;

    procedure Include(const AItem: T);
    procedure Exclude(const AItem: T);

    procedure Clear;
  end;


  TStringDictionary<TValue> = class(TDictionary<string, TValue>)
  public
    constructor Create(ACaseSensitive: boolean = true);
  end;


  TStringObjectDictionary<TValue> = class(TObjectDictionary<string, TValue>)
  public
    constructor Create(
      AOwnerships: TDictionaryOwnerships; ACaseSensitive: boolean = true);
  end;


implementation

uses
  SysUtils,
  krn_StringUtils;

(*
{ THashedStringList }

procedure THashedStringList.Add(const AStr: string);
var
  s: string;
begin
  s := LowerCase(AStr);
  if FHash.Exists(s) then
    Exit;

  FList.Add(AStr);
  FHash[s] := 1;
end;


function THashedStringList.Count: integer;
begin
  Result := FList.Count;
end;


constructor THashedStringList.Create;
begin
  inherited Create;
  FHash := TBHashTable.Create;
  FList := TStringList.Create;
end;


procedure THashedStringList.Delete(AIndex: integer);
begin
  FHash.Delete(LowerCase(FList[AIndex]));
  FList.Delete(AIndex);
end;


destructor THashedStringList.Destroy;
begin
  FList.Free;
  inherited;
end;


function THashedStringList.Get(AIndex: integer): string;
begin
  Result := FList[AIndex];
end;


function THashedStringList.GetEnumerator: TStringsEnumerator;
begin
  Result := FList.GetEnumerator;
end;


procedure THashedStringList.Put(AIndex: integer; const AValue: string);
begin
  FList[AIndex] := AValue;
end;
*)

{ TSet<T> }

procedure TSet<T>.Clear;
begin
  FItems.Clear;
end;


function TSet<T>.Count: integer;
begin
  Result := FItems.Count;
end;


constructor TSet<T>.Create;
begin
  inherited Create;
  FItems := TDictionary<T, boolean>.Create;
end;


destructor TSet<T>.Destroy;
begin
  FItems.Free;
  inherited;
end;


function TSet<T>.DoGetEnumerator: TEnumerator<T>;
begin
  Result := FItems.Keys.GetEnumerator;
end;


procedure TSet<T>.Exclude(const AItem: T);
begin
  FItems.Remove(AItem);
end;


function TSet<T>.Has(const AItem: T): boolean;
begin
  Result := FItems.ContainsKey(AItem);
end;


procedure TSet<T>.Include(const AItem: T);
begin
  FItems.AddOrSetValue(AItem, true);
end;


{ TStringDictionary<TValue> }

constructor TStringDictionary<TValue>.Create(ACaseSensitive: boolean);
begin
  if ACaseSensitive then
    inherited Create
  else
    inherited Create(TCaseInsensitiveStringComparer.Create);
end;


{ TStringObjectDictionary<TValue> }

constructor TStringObjectDictionary<TValue>.Create(
  AOwnerships: TDictionaryOwnerships; ACaseSensitive: boolean);
begin
  if ACaseSensitive then
    inherited Create(AOwnerships)
  else
    inherited Create(AOwnerships, TCaseInsensitiveStringComparer.Create);
end;


end.
