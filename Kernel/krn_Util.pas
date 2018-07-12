unit krn_Util;

interface

uses
  Classes, SQLTimSt, Types, Math, DB, Generics.Collections,
  rs, rs_std,
  krn_const, krn_Types, krn_CoatedObject, krn_Storage, krn_AttrInfo;

type
  IUSLocale = interface
  end;


  TUSLocale = class(TInterfacedObject, IUSLocale)
  private
    FDateFormat: string;
    FTimeFormat: string;
    FDateSep: char;
    FDecimalSep: char;
    FThousSep: char;
    FListSep: char;
    FLongMonths: array[1..12] of string;
    FShortMonths: array[1..12] of string;
  public
    constructor Create;
    destructor Destroy; override;
  end;


  TVisualizeStatus = (vsStarted, vsProgress, vsFinished, vsFailed);


  IStatusVisualizer = interface
  ['{B5D97802-7BC3-4A96-98B1-EDA8077E05F7}']
    procedure Started;
    procedure Finished;
    procedure Failed;
    procedure Progress(const Current, Total: integer);
  end;


  TConditionOperator = (coAND, coOR);


  IConditionBuilder = interface
  ['{58D4D725-90CC-47C6-89CD-F26D911226FC}']
    function GetCond: string;
    function GetParams: TArrayOfVariant;
    function GetOleParams: TOleVariantDynArray;

    procedure Add(const ACond: string); overload;
    procedure Add(const ACond: string; AParams: array of variant); overload;
    procedure Add(ABuilder: IConditionBuilder); overload;
    procedure AddIfNotEmpty(const ACond: string; const AParam: variant);

    procedure Clear;

    property Cond: string read GetCond;
    property Params: TArrayOfVariant read GetParams;
    property OleParams: TOleVariantDynArray read GetOleParams;
  end;


  TConditionBuilder = class(TInterfacedObject, IConditionBuilder)
  private
    FCondOper: TConditionOperator;
    FCond: string;
    FParams: TArrayOfVariant;
    FInlineParams: boolean;

    class function IsParamEmpty(const AParam: variant): boolean;

    function GetCond: string;
    function GetParams: TArrayOfVariant;
    function GetOleParams: TOleVariantDynArray;

    procedure AddCond(ACond: string);
  public
    class function JoinParams(
      ABuilders: array of IConditionBuilder): TArrayOfVariant;

    constructor Create(
      AInlineParams: boolean = false; ACondOper: TConditionOperator = coAND);

    procedure Add(const ACond: string); overload;
    procedure Add(const ACond: string; AParams: array of variant); overload;
    procedure Add(ABuilder: IConditionBuilder); overload;
    procedure AddIfNotEmpty(const ACond: string; const AParam: variant);

    procedure Clear;

    property Cond: string read GetCond;
    property Params: TArrayOfVariant read GetParams;
  end;


  TStringsKeyValueEnumerator = class(TEnumerator<TPair<string, string>>)
  private
    FSource: TStrings;
    FIndex: integer;
    FCurrent: TPair<string, string>;
  protected
    function DoGetCurrent: TPair<string, string>; override;
    function DoMoveNext: boolean; override;
  public
    constructor Create(ASource: TStrings);
  end;


  procedure VisualizeStatus(
    const AStatusVisualizer: IStatusVisualizer;
    const AVisualizeStatus: TVisualizeStatus; const ACurrent: integer = 0;
    const ATotal: integer = 0);

  function VarIsNothing(const V: variant): boolean;
  function SafeVarToInt(const V: variant): integer;
  function SafeVarToFloat(const V: variant): double;
  function SafeVarToCurr(const V: variant): currency;
  function SafeVarToBoolean(const V: variant): boolean;
  function SafeVarToDateTime(const V: variant): TDateTime;
  function SafeVarToSQLTimeStamp(const V: variant): TSQLTimeStamp;
  function SafeVarWithoutNulls(const V: variant): variant;
  function VarToInterface(const AValue: variant): IUnknown;
  function EmptyVarToNull(const AValue: variant): variant;

  function VarTypeToAttrType(AVarType: TVarType): TAttrType;

  function VarRecToStr(const AValue: TVarRec): string;

  function CompareSameTypeVariants(
    const V1, V2: variant; ANullsLast: boolean): integer;
  // compares simple types by values and complex types by pointer values
  function CompareSameTypeVarRecs(const ARec1, ARec2: TVarRec): integer;

  function BuildSQL(
    const FieldList, TableName: string; const Condition: string = '';
    const Distinct: boolean = false; const OrderBy: string = ''): string;
  procedure CheckSQLConditionParameterValidness(const Parameter: string);
  function AddCondition(
    const Source, Cond: string; AFrameExistedCondition: boolean = true): string;
  procedure AddParameter(var AParams: TArrayOfVariant; const AParam: variant);
  function CombineParameters(
    const AParams: array of olevariant): TOleVariantDynArray;
  function ReplaceFieldsInSortString(
    const ASortString: string;
    const AOldFields, ANewFields: array of string): string;

  function ConstructVariantArray(
    const AValues: array of variant): TArrayOfVariant;
  function JoinVariantArrays(
    const AArrays: array of TArrayOfVariant): TArrayOfVariant;

  procedure AddOleParameter(
    var AParams: TOleVariantDynArray; const AParam: variant);
  function DuplicateQuotes(const Source: string): string;

  function PrepareCSVString(const Source: string): string;
  function StartsWith(const SubStr, Str: string): boolean;

  function BreakString(
    const Source: string; const Sep: char = ';'): TStringDynArray;
  procedure AddString(const Source: string; var Strings: TStringDynArray);
  function ConstructString(
    const Source: TStringDynArray; const Sep: char = ';'): string;
  procedure DeleteString(var Source: TStringDynArray; const Index: integer);
  function IndexOfString(
    const Source: TStringDynArray; const S: string): integer;
  function IndexOfText(
    const Source: TStringDynArray; const S: string): integer;
  function ConstructStringDynArray(
    const ASource: array of string): TStringDynArray;
  function JoinStringArrays(
    const AArray1, AArray2: array of string): TStringDynArray;
  procedure CopyStringArray(
    var ADest: array of string; const ASource: array of string;
    var ADestOffset: integer);
  function AddSeparated(const ASource, ANewString, ASeparator: string): string;
  function RemoveLineBreaks(const ASource: string): string;
  function LastPos(const ASubStr, AStr: string): integer;
  function StringListToArray(AList: TStrings): TStringDynArray;
  function ArrayToQuotedItemsString(
    const ASource: array of string; const ASep: string = ', ';
    const AQuote: string = ''''): string;

  function FloatCompare(
    const Num1, Num2: double;
    const Precision: double = DEFAULT_COMPARE_PRECISION): integer;
  function RoundEx(
    const Value: double;
    const Precision: double = DEFAULT_COMPARE_PRECISION): double;
  function RoundToEx(
    const Value: double; const Digit: TRoundToRange = -2): double;
  function FloatEqual(
    const Num1, Num2: double;
    const Precision: double = DEFAULT_COMPARE_PRECISION): boolean;
  function SafeDiv(const A, B: double): double;
  function SmartTrunc(const ANum: double): integer;
  function FloatInc(var AValue: double; const ADelta: double): double;
  function FloatToStrPoint(const AValue: double): string;
  function IsNumericString(
    const AValue: string; ASigned: boolean = false): boolean;

  function ConstructOleVariantArray(
    const ASource: array of olevariant): TOleVariantDynArray;
  function ConvertArrayVariantToOleVariant(
    const ASource: TArrayOfVariant): TOleVariantDynArray;
  procedure AddOleVariant(
    const AVal: olevariant; var AVals: TOleVariantDynArray);

  function GetWindowsUserName: string;
  function UnseparatedDate(ADate: TDateTime): string; overload;
  function UnseparatedDate(const ADateStr: string): string; overload;

  procedure ClearObjectedStrings(Strings: TStrings);
  procedure FreeAndNilObjectedStrings(var Strings);
  function CreateSortedStrings(const IgnoreDuplicates: boolean): TStringList;
  procedure ClearPointerList(AList: TList);
  procedure FreeAndNilPointerList(var AList: TList);

  function MMMYYDate(const S: string; out Value: TDateTime): boolean;
  function MonthNum(const ShortName: string; out Value: integer): boolean;
  function ClosestEndOfMonth(ADate: TDateTime): TDateTime;

  function Guard(AObject: TObject): IUnknown;
  function GetTempPath: string;
  function GetTempFile: string;
  procedure EnsureFile(const AFileName: string);

  function DoubleArray(const AValues: array of double): TDoubleDynArray;

  function GetMMYYDateFilterCondition(
    const AFieldName, AValue: string; ACond: integer): string;

  function GetBooleanFilterCondition(
    const AFieldName, AValue: string; ACond: integer): string;
  function GetDateFilterCondition(
    const AFieldName, AValue: string; ACond: integer): string;
  function GetFloatFilterCondition(
    const AFieldName, AValue: string; ACond: integer): string;
  function GetTimeStampDateFilterCondition(
    const AFieldName, AValue: string; ACond: integer): string;
  function GetStringFilterCondition(
    const AFieldName, AValue: string; ACond: integer;
    AMatchCase: boolean): string;

  function BinaryToHex(const ABinary; const ASize: integer): string;
  // Converts AHex to binary representation, if ABinary = nil, memory is
  // allocated by HexToBinary, should be deallocated by caller. If
  // ABinary <> nil, size of memory allocated for ABinary should be >=
  // Length(AHex) / 2, Length(AHex) should be an even number
  procedure HexToBinary(const AHex: string; var ABinary: pointer);

  function ClassToStr(const AClass: TClass): string;

  function GetFileList(const AMask: string; const AAttrs: integer): TStringList;

  procedure CloseDataSet(ADataSet: TDataSet);

  function ExpandRelativePath(const ABase, APath: string): string;
  function ExpandEXERelativePath(const APath: string): string;

  procedure WriteStream(
    ASource, ADest: TStream; const ABufSize: cardinal = 32768);

  function IsClass(AObject: TObject; const AClasses: array of TClass): boolean;

  procedure DeleteDirectoryReqursive(const ADir: string; AKeepItself: boolean);

  procedure SafeDeleteFile(const AFileName: string);

  // creates datasource and dataset for given data
  // intended for reducing quantity of designtime components on forms
  function FastCreateDataSource(
    AOwner: TComponent; AData: TPersistent): TDataSource;

  function ConstructSQL(
    const AFieldList, ADBClassName, ACondition, AOrderBy: string;
    const ADistinct: boolean; const ASQLAlias: string = '';
    const AJoinBlock: string = ''): string;

  function ParamsToArray(AParams: TParams): TArrayOfVariant;
  function ParamsToString(AParams: TParams): string;

  function GetExcelCol(AColIdx: integer): string;
  function GetExcelCell(AColIdx, ARowIdx: integer): string;

  procedure SaveDataSetToFile(ADataSet: TDataSet; const AFileName: string);

  procedure GridDataSetRecordDelete(AGrid: TDBGridPro; ARecNo: integer);

  function SwitchToUSLocale: IUSLocale;

  procedure ValueListToCollection(
    const AValueList: string; ACollection: TCoatedCollection;
    const AAttrName: string);
  function CollectionToValueList(
    ACollection: TCoatedCollection; const AAttrName: string): string;

  procedure SaveBLOBToFile(ABlob: TBlob; const AFileName: string);

  function FilterChainedFields(const AFields: TStringDynArray): TStringDynArray;

implementation

uses
  Windows, SysUtils, Variants, DateUtils, DBConsts, StrUtils, Forms,
  UBUtils,
  rs_db, rs_rtm,
  krn_Exception, krn_SQLExprVariableProcessor, krn_kernel,
  krn_Containers;

type
  TGuard = class(TInterfacedObject, IUnknown)
  private
    FObject: TObject;
  public
    constructor Create(AObject: TObject);
    destructor Destroy; override;
  end;


procedure VisualizeStatus(
  const AStatusVisualizer: IStatusVisualizer;
  const AVisualizeStatus: TVisualizeStatus; const ACurrent, ATotal: integer);
begin
  if (AStatusVisualizer <> nil) then
    case AVisualizeStatus of
      vsStarted: AStatusVisualizer.Started;
      vsProgress: AStatusVisualizer.Progress(ACurrent, ATotal);
      vsFinished: AStatusVisualizer.Finished;
      vsFailed: AStatusVisualizer.Failed;
    end;
end;


function VarIsNothing(const V: variant): boolean;
begin
  Result := VarIsClear(V) or VarIsNull(V);
end;


function SafeVarToInt(const V: variant): integer;
begin
  if VarIsNothing(V) then
    Result := 0
  else
    Result := V;
end;


function SafeVarToFloat(const V: variant): double;
begin
  if VarIsNothing(V) then
    Result := 0.0
  else
    Result := V;
end;


function SafeVarToCurr(const V: variant): currency;
begin
  if VarIsNothing(V) then
    Result := 0.0
  else
    Result := V;
end;


function SafeVarToBoolean(const V: variant): boolean;
begin
  if VarIsNothing(V) then
    Result := false
  else
    Result := V;
end;


function SafeVarToDateTime(const V: variant): TDateTime;
begin
  if VarIsNothing(V) then
    Result := 0
  else
    Result := V;
end;


function SafeVarToSQLTimeStamp(const V: variant): TSQLTimeStamp;
begin
  if VarIsNothing(V) then begin
    Result.Year := 0;
    Result.Month := 0;
    Result.Day := 0;
    Result.Hour := 0;
    Result.Minute := 0;
    Result.Second := 0;
    Result.Fractions := 0;
  end
  else
    try
      Result := VarToSQLTimeStamp(V);
    except
      raise EConvertError.Create(SInvalidSqlTimeStamp);
    end;
end;


function SafeVarWithoutNulls(const V: variant): variant;
begin
  if VarIsNothing(V) then
    Result := ''
  else
    Result := V;
end;


function VarToInterface(const AValue: variant): IUnknown;
begin
  Result := AValue;
end;


function EmptyVarToNull(const AValue: variant): variant;
begin
  // empty strings should be NULL
  if VarIsStr(AValue) and (VarToStr(AValue) = '') then
    Result := Null
  // zero date params should be NULL
  else if (VarType(AValue) = varDate) and (AValue = 0) then
    Result := Null
  else
    Result := AValue;
end;


function VarTypeToAttrType(AVarType: TVarType): TAttrType;
begin
  case AVarType of
    varSmallint, varInteger, varShortInt, varByte, varWord, varLongWord,
    varInt64, varUInt64:
      Result := atInteger;
    varSingle, varDouble:
      Result := atFloat;
    varCurrency:
      Result := atCurrency;
    varDate:
      Result := atDateTime;
    varOleStr, varString, varUString:
      Result := atString;
    varBoolean:
      Result := atBoolean;
    else
      Result := atUnknown;
  end;
end;


function VarRecToStr(const AValue: TVarRec): string;
begin
  Result := '';
  case AValue.VType of
    vtInteger:
      Result := IntToStr(AValue.VInteger);
    vtBoolean:
      Result := BoolToStr(AValue.VBoolean, true);
    vtChar:
      Result := string(AValue.VChar);
    vtExtended:
      Result := FloatToStr(AValue.VExtended^);
    vtString:
      Result := string(AValue.VString^);
    vtPointer, vtInterface:
      Result := Format('$%p', [AValue.VPointer]);
    vtPChar:
      Result := string(AValue.VPChar);
    vtObject:
      Result := AValue.VObject.ToString + Format(' @ $%p', [AValue.VPointer]);
    vtClass:
      Result := AValue.VClass.ClassName;
    vtWideChar:
      Result := AValue.VWideChar;
    vtPWideChar:
      Result := AValue.VPWideChar;
    vtAnsiString:
      Result := string(AValue.VAnsiString);
    vtCurrency:
      Result := CurrToStr(AValue.VCurrency^);
    vtVariant:
      Result := VarToStr(AValue.VVariant^);
    vtWideString:
      Result := widestring(AValue.VWideString);
    vtInt64:
      Result := IntToStr(AValue.VInt64^);
    vtUnicodeString:
      Result := unicodestring(AValue.VUnicodeString);
  end;
end;


function CompareSameTypeVariants(
  const V1, V2: variant; ANullsLast: boolean): integer;
begin
  Result := 0;
  if VarIsNothing(V1) then begin
    if not VarIsNothing(V2) then
      Result := IfThen(ANullsLast, 1, -1);
  end
  else if VarIsNothing(V2) then
    Result := IfThen(ANullsLast, -1, 1)
  else if V1 < V2 then
    Result := -1
  else if V1 > V2 then
    Result := 1;
end;


function CompareSameTypeVarRecs(const ARec1, ARec2: TVarRec): integer;
begin
  Assert(ARec1.VType = ARec2.VType);
  Result := 0;
  case ARec1.VType of
    vtInteger:
      Result := ARec1.VInteger - ARec2.VInteger;
    vtBoolean:
      Result := integer(ARec1.VBoolean) - integer(ARec2.VBoolean);
    vtChar:
      Result := integer(ARec1.VChar) - integer(ARec2.VChar);
    vtExtended:
      Result := CompareValue(ARec1.VExtended^, ARec2.VExtended^);
    vtString:
      Result := CompareStr(string(ARec1.VString^), string(ARec2.VString^));
    vtPointer, vtObject, vtClass, vtInterface:
      Result := cardinal(ARec1.VPointer) - cardinal(ARec2.VPointer);
    vtPChar:
      Result := AnsiStrComp(ARec1.VPChar, ARec2.VPChar);
    vtWideChar:
      Result := integer(ARec1.VWideChar) - integer(ARec2.VWideChar);
    vtPWideChar:
      Result := StrComp(ARec1.VPWideChar, ARec2.VPWideChar);
    vtAnsiString:
      Result :=
        AnsiCompareStr(string(ARec1.VAnsiString), string(ARec2.VAnsiString));
    vtCurrency:
      Result := CompareValue(ARec1.VCurrency^, ARec2.VCurrency^);
    vtVariant:
      begin
        Assert(VarType(ARec1.VVariant^) = VarType(ARec2.VVariant^));
        Result :=
          CompareSameTypeVariants(ARec1.VVariant^, ARec2.VVariant^, true);
      end;
    vtWideString:
      Result :=
        CompareStr(
          widestring(ARec1.VWideString), widestring(ARec2.VWideString));
    vtInt64:
      Result := CompareValue(ARec1.VInt64^, ARec2.VInt64^);
    vtUnicodeString:
      Result :=
        CompareStr(
          unicodestring(ARec1.VUnicodeString),
          unicodestring(ARec2.VUnicodeString));
  end;
  Result := Sign(Result);
end;


procedure RaiseErrorFmt(
  const ErrorMessage: string; const Args: array of const);
var
  s: string;
begin
  FmtStr(s, ErrorMessage, Args);
  raise Exception.Create(s);
end;


function BuildSQL(
  const FieldList, TableName, Condition: string;
  const Distinct: boolean; const OrderBy: string): string;
const
  QUERIES: array [boolean] of string =
    ('SELECT %s FROM %s', 'SELECT DISTINCT %s FROM %s');
begin
  Result := Format(QUERIES[Distinct], [FieldList, TableName]);
  if (Condition <> '') then
    Result := Format('%s WHERE %s', [Result, Condition]);
  if (OrderBy <> '') then
    Result := Format('%s ORDER BY %s', [Result, OrderBy]);
end;


procedure CheckSQLConditionParameterValidness(const Parameter: string);
var
  c: char;
begin
  c := #0;
  if (Pos('"', Parameter) <> 0) then
    c := '"'
  else if (Pos('''', Parameter) <> 0) then
    c := ''''
  else if (Pos('%', Parameter) <> 0) then
    c := '%';
  if (c <> #0) then
    RaiseGUIErrorFmt(ILLEGAL_FILTER_PARAMETER, [c]);
end;


function AddCondition(
  const Source, Cond: string; AFrameExistedCondition: boolean): string;
begin
  if (Source = '') then begin
     if (Cond <> '') then
       Result := '(' + Cond + ')'
     else
       Result := Cond;
  end
  else begin
    if AFrameExistedCondition then
      Result := '(' + Source + ')'
    else
      Result := Source;
    if (Cond <> '') then
      Result := Format('%s AND (%s)', [Result, Cond]);
  end;
end;


procedure AddParameter(var AParams: TArrayOfVariant; const AParam: variant);
var
  len: integer;
begin
  len := Length(AParams);
  SetLength(AParams, len + 1);
  AParams[len] := AParam;
end;


function CombineParameters(
  const AParams: array of olevariant): TOleVariantDynArray;
var
  i, j, k, n: integer;
begin
  n := 0;
  for i := 0 to Length(AParams) - 1 do begin
    if VarIsArray(AParams[i]) then
      n := n + VarArrayHighBound(AParams[i], 1) + 1
    else
      Inc(n);
  end;
  SetLength(Result, n);
  k := 0;
  for i := 0 to Length(AParams) - 1 do begin
    if VarIsArray(AParams[i]) then
      for j := 0 to VarArrayHighBound(AParams[i], 1) do begin
        Result[k] := AParams[i][j];
        Inc(k);
      end
    else begin
      Result[k] := AParams[i];
      Inc(k);
    end;
  end;
end;


function ReplaceFieldsInSortString(
  const ASortString: string;
  const AOldFields, ANewFields: array of string): string;
var
  l, it: TStringDynArray;
  i: integer;
  dict: TStringDictionary<string>;
  newField: string;
begin
  Result := ASortString;
  if
    (ASortString = '') or (Length(AOldFields) = 0) or (Length(ANewFields) = 0)
  then
    Exit;

  Assert(Length(AOldFields) = Length(ANewFields));

  dict := TStringDictionary<string>.Create(false);
  try
    for i := 0 to Length(AOldFields) - 1 do
      dict.Add(AOldFields[i], ANewFields[i]);
    l := UBUtils.BreakString(ASortString, ',', true);
    for i := 0 to High(l) do begin
      it := BreakString(l[i], ' ');
      if (it <> nil) then begin
        if dict.TryGetValue(it[0], newField) then
          it[0] := newField;
        l[i] := ConstructString(it, ' ');
      end;
    end;
    Result := ConstructString(l, ',');
  finally
    dict.Free;
  end;
end;


function ConstructVariantArray(
  const AValues: array of variant): TArrayOfVariant;
var
  i: integer;
begin
  SetLength(Result, Length(AValues));
  for i := 0 to High(AValues) do
    Result[i] := AValues[i];
end;


function JoinVariantArrays(
  const AArrays: array of TArrayOfVariant): TArrayOfVariant;
var
  i: integer;
  j: integer;
  n: integer;
begin
  n := 0;
  for i := 0 to High(AArrays) do
    n := n + Length(AArrays[i]);
  SetLength(Result, n);

  n := 0;
  for i := 0 to High(AArrays) do begin
    for j := 0 to High(AArrays[i]) do begin
      Result[n] := AArrays[i][j];
      Inc(n);
    end;
  end;
end;


procedure AddOleParameter(
  var AParams: TOleVariantDynArray; const AParam: variant);
var
  len: integer;
begin
  len := Length(AParams);
  SetLength(AParams, len + 1);
  AParams[len] := AParam;
end;


function DuplicateQuotes(const Source: string): string;
begin
  Result := StringReplace(Source, '''', '''''', [rfReplaceAll]);
end;


function PrepareCSVString(const Source: string): string;
var
  i: integer;
begin
  // CSV file contains one byte symbols (RFC4180)
  // TEXTDATA =  %x20-21 / %x23-2B / %x2D-7E
  if (Source = '') then
    Result := ''
  else begin
    Result := '"';
    for i := 1 to Length(Source) do
      case Source[i] of
        '"':
          Result := Result + '""';
        #0..#31:
          Result := Result + ' ';
        else
          Result := Result + Source[i];
      end;
    Result := Result + '"';
  end;
end;


function StartsWith(const SubStr, Str: string): boolean;
begin
  Result := (Copy(Str, 1, Length(SubStr)) = SubStr);
end;


function BreakString(const Source: string; const Sep: char): TStringDynArray;
var
  i, j: integer;
  s: string;
  cnt: integer;
begin
  Result := nil;
  if (Source <> '') then begin
    cnt := 1;
    for i := 1 to Length(Source) do
      if (Source[i] = Sep) then
        Inc(cnt);
    SetLength(Result, cnt);
    s := '';
    j := Low(Result);
    for i := 1 to Length(Source) do
      if (Source[i] = Sep) then begin
        Result[j] := s;
        Inc(j);
        s := '';
      end
      else
        s := s + Source[i];
    if (s <> '') then
      Result[j] := s;
  end;
end;


procedure AddString(const Source: string; var Strings: TStringDynArray);
begin
  SetLength(Strings, Length(Strings) + 1);
  Strings[High(Strings)] := Source;
end;


function ConstructString(
  const Source: TStringDynArray; const Sep: char): string;
var
  i: integer;
begin
  if (Source <> nil) then begin
    Result := Source[Low(Source)];
    for i := Low(Source) + 1 to High(Source) do
      Result := Result + Sep + Source[i];
  end
  else
    Result := '';
end;


procedure DeleteString(var Source: TStringDynArray; const Index: integer);
var
  i: integer;
begin
  for i := Index to High(Source) - 1 do
    Source[i] := Source[i + 1];
  SetLength(Source, Length(Source) - 1);
end;


function IndexOfString(const Source: TStringDynArray; const S: string): integer;
var
  i: integer;
begin
  Result := Low(Source) - 1;
  for i := Low(Source) to High(Source) do
    if (Source[i] = S) then begin
      Result := i;
      Break;
    end;
end;


function IndexOfText(const Source: TStringDynArray; const S: string): integer;
var
  i: integer;
begin
  Result := Low(Source) - 1;
  for i := Low(Source) to High(Source) do
    if AnsiSameText(Source[i], S) then begin
      Result := i;
      Break;
    end;
end;


function ConstructStringDynArray(
  const ASource: array of string): TStringDynArray;
var
  i: integer;
begin
  SetLength(Result, Length(ASource));
  for i := 0 to High(Result) do
    Result[i] := ASource[i];
end;


function JoinStringArrays(
  const AArray1, AArray2: array of string): TStringDynArray;
var
  n1, n2: integer;
  i: integer;
begin
  n1 := Length(AArray1);
  n2 := Length(AArray2);
  SetLength(Result, n1 + n2);
  for i := 0 to n1 - 1 do
    Result[i] := AArray1[i];
  for i := 0 to n2 - 1 do
    Result[n1 + i] := AArray2[i];
end;


function ConstructOleVariantArray(
  const ASource: array of olevariant): TOleVariantDynArray;
var
  i: integer;
begin
  SetLength(Result, Length(ASource));
  for i := 0 to High(ASource) do
    Result[i] := ASource[i];
end;


function ConvertArrayVariantToOleVariant(
  const ASource: TArrayOfVariant): TOleVariantDynArray;
var
  i, n: integer;
begin
  n := Length(ASource);
  SetLength(Result, n);
  for i := 0 to n - 1 do
    Result[i] := ASource[i];
end;


procedure AddOleVariant(const AVal: olevariant; var AVals: TOleVariantDynArray);
begin
  SetLength(AVals, Length(AVals) + 1);
  AVals[High(AVals)] := AVal;
end;


procedure CopyStringArray(
  var ADest: array of string; const ASource: array of string;
  var ADestOffset: integer);
var
  i: integer;
begin
  for i := 0 to High(ASource) do begin
    ADest[ADestOffset] := ASource[i];
    Inc(ADestOffset);
  end;
end;


function AddSeparated(const ASource, ANewString, ASeparator: string): string;
begin
  if ASource = '' then
    Result := ANewString
  else if ANewString = '' then
    Result := ASource
  else
    Result := ASource + ASeparator + ANewString;
end;


function RemoveLineBreaks(const ASource: string): string;
begin
  Result := StringReplace(ASource, #13, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #10, '', [rfReplaceAll]);
end;


function LastPos(const ASubStr, AStr: string): integer;
begin
  Result := Pos(ReverseString(ASubStr), ReverseString(AStr));

  if (Result <> 0) then
   Result := ((Length(AStr) - Length(ASubStr)) + 1) - Result + 1;
end;


function StringListToArray(AList: TStrings): TStringDynArray;
var
  i: integer;
begin
  SetLength(Result, AList.Count);
  for i := 0 to AList.Count - 1 do
    Result[i] := AList[i];
end;


function ArrayToQuotedItemsString(
  const ASource: array of string; const ASep: string;
  const AQuote: string): string;
var
  i: integer;
begin
  if Length(ASource) = 0 then
    Result := ''
  else begin
    Result := AQuote + ASource[Low(ASource)] + AQuote;
    for i := Low(ASource) + 1 to High(ASource) do
      Result := Result + ASep + AQuote + ASource[i] + AQuote;
  end;
end;


function FloatCompare(const Num1, Num2, Precision: double): integer;
var
  dif: double;
begin
  dif := Num1 - Num2;
  if (Abs(dif) <= Precision) then
    Result := 0
  else if (dif < 0.0) then
    Result := -1
  else
    Result := 1;
end;


// This function provides Round functionality in some interesting cases when
// we have precision losses working on double-precision numbers
function RoundEx(const Value, Precision: double): double;
begin
  Result := Abs(Value);
  if (FloatCompare(Frac(Result), 0.5, Precision) >= 0) then
    Result := Int(Result) + 1
  else
    Result := Int(Result);
  if (Value < 0) then
    Result := -Result;
end;


// This function is a fix to a co-processor rounding error. Original RoundTo
// function always uses division in calculations, we'll use multiplication
// on negative ADigit
function RoundToEx(
  const Value: double; const Digit: TRoundToRange): double;
var
  lFactor: extended;
begin
  if (Digit <= 0) then begin
    lFactor := IntPower(10, -Digit);
    Result := RoundEx(Value * lFactor) / lFactor;
  end
  else begin
    lFactor := IntPower(10, Digit);
    Result := RoundEx(Value / lFactor) * lFactor;
  end;
end;


function FloatEqual(const Num1, Num2, Precision: double): boolean;
begin
  Result := (FloatCompare(Num1, Num2, Precision) = 0);
end;


function SafeDiv(const A, B: double): double;
begin
  if FloatEqual(B, 0.0) then
    Result := 0.0
  else
    Result := A / B;
end;


function SmartTrunc(const ANum: double): integer;
begin
  if FloatEqual(ANum, Round(ANum)) then
    Result := Round(ANum)
  else
    Result := Trunc(ANum);
end;


function FloatInc(var AValue: double; const ADelta: double): double;
begin
  AValue := AValue + ADelta;
  Result := AValue;
end;


function FloatToStrPoint(const AValue: double): string;
var
  ch: char;
begin
  ch := DecimalSeparator;
  DecimalSeparator := '.';
  try
    Result := FloatToStr(AValue);
  finally
    DecimalSeparator := ch;
  end;
end;


function IsNumericString(const AValue: string; ASigned: boolean): boolean;
var
  i: integer;
  len: integer;
begin
  Result := false;
  if AValue = '' then
    Exit;

  len := Length(AValue);
  for i := 1 to len do begin
    if (i = 1) and ASigned and (len > 1) and (AValue[i] = '-') then
      Continue;

    if not CharInSet(AValue[i], ['0'..'9']) then
      Exit;
  end;

  Result := true;
end;


function GetWindowsUserName: string;
var
  name: array[0..1024] of char;
  size: cardinal;
begin
  size := 1024;
  Windows.GetUserName(@name, size);
  SetLength(Result, size);
  Result := name;
end;


function UnseparatedDate(ADate: TDateTime): string;
var
  fmt: string;
  i: integer;
  metYear, metMonth, metDay: boolean;
begin
  fmt := '';
  metYear := false;
  metMonth := false;
  metDay := false;
  for i := 1 to Length(ShortDateFormat) do begin
    case ShortDateFormat[i] of
      'd', 'D':
        begin
          if not metDay then
            fmt := fmt + StringOfChar(ShortDateFormat[i], 2);
          metDay := true;
        end;
      'm', 'M':
        begin
          if not metMonth then
            fmt := fmt + StringOfChar(ShortDateFormat[i], 2);
          metMonth := true;
        end;
      'y', 'Y':
        begin
          if not metYear then
            fmt := fmt + StringOfChar(ShortDateFormat[i], 4);
          metYear := true;
        end;
      else
        fmt := fmt + ShortDateFormat[i];
    end;
  end;
  Result :=
    StringReplace(
      FormatDateTime(fmt, ADate), DateSeparator, '', [rfReplaceAll]);
end;


function UnseparatedDate(const ADateStr: string): string;
var
 i, n, k: integer;
begin
  n := Length(ADateStr);
  SetLength(Result, n);
  k := 0;
  for i := 1 to n do
    if CharInSet(ADateStr[i], ['0'..'9']) then begin
      Inc(k);
      Result[k] := ADateStr[i];
    end;
  SetLength(Result, k);
end;


procedure ClearObjectedStrings(Strings: TStrings);
var
  i: integer;
begin
  if Strings <> nil then begin
    for i := 0 to Strings.Count - 1 do
      Strings.Objects[i].Free;

    Strings.Clear;
  end;
end;


procedure FreeAndNilObjectedStrings(var Strings);
begin
  ClearObjectedStrings(TStrings(Strings));
  FreeAndNil(Strings);
end;


function CreateSortedStrings(const IgnoreDuplicates: boolean): TStringList;
begin
  Result := TStringList.Create;
  try
    Result.Sorted := true;
    if IgnoreDuplicates then
      Result.Duplicates := dupIgnore
    else
      Result.Duplicates := dupError;
  except
    Result.Free;
    raise;
  end;
end;


procedure ClearPointerList(AList: TList);
var
  i: integer;
begin
  for i := 0 to AList.Count - 1 do
    if (AList[i] <> nil) then
      Dispose(AList[i]);
  AList.Clear;
end;


procedure FreeAndNilPointerList(var AList: TList);
begin
  ClearPointerList(AList);
  FreeAndNil(AList);
end;


function MMMYYDate(const S: string; out Value: TDateTime): boolean;
var
  y, m: integer;
  incr: integer;
  dt: TDateTime;
  vals: TStringDynArray;
begin
  vals := BreakString(S, ' ');
  Result :=
    (Length(vals) > 0) and (Length(vals) <= 2) and MonthNum(Trim(vals[0]), m);
  if Result then begin
    if (Length(vals) = 1) then
      Result := TryEncodeDate(YearOf(EffDate), m, 1, Value)
    else begin
      Result :=
        TryStrToInt(Trim(vals[1]), y) and (y >= Low(word)) and
        (y <= High(word));
      if Result then begin
        if (y < 100) then begin
          dt := EffDate;
          incr := 0;
          if (y - YearOf(dt) mod 100 > 50) then
            incr := -1
          else if (y - YearOf(dt) mod 100 < -50) then
            incr := 1;
          y := y + (YearOf(dt) div 100 + incr) * 100
        end;
        Result := TryEncodeDate(y, m, 1, Value);
      end;
    end;
  end;
end;


function MonthNum(const ShortName: string; out Value: integer): boolean;
var
  i: integer;
begin
  Result := false;
  for i := Low(ShortMonthNames) to High(ShortMonthNames) do
    if AnsiSameText(ShortName, ShortMonthNames[i]) then begin
      Value := i;
      Result := true;
      Break;
    end;
end;


function ClosestEndOfMonth(ADate: TDateTime): TDateTime;
var
  monthStart: TDateTime;
begin
  monthStart := EncodeDate(YearOf(ADate), MonthOf(ADate), 1);
  if DayOf(ADate) > (DaysInMonth(ADate) div 2) then
    monthStart := IncMonth(monthStart, 1);
  Result := IncDay(monthStart, -1)
end;


function Guard(AObject: TObject): IUnknown;
begin
  Result := TGuard.Create(AObject);
end;


function GetTempPath: string;
var
  tmpPath: string;
begin
  SetLength(tmpPath, Windows.MAX_PATH);
  if (Windows.GetTempPath(Windows.MAX_PATH, PChar(tmpPath)) = 0) then
    RaiseLastOSError;
  Result := PChar(tmpPath);
end;


function GetTempFile: string;
var
  tmpPath, tmpFileName: string;
begin
  tmpPath := GetTempPath;
  SetLength(tmpFileName, Windows.MAX_PATH);
  if (GetTempFileName(PChar(tmpPath), 'tmp', 0, PChar(tmpFileName)) = 0) then
    RaiseLastOSError;
  Result := PChar(tmpFileName);
end;


procedure EnsureFile(const AFileName: string);
begin
  if not FileExists(AFileName) then
    TFileStream.Create(AFileName, fmCreate).Free;
end;


function DoubleArray(const AValues: array of double): TDoubleDynArray;
var
  i: integer;
begin
  SetLength(Result, Length(AValues));
  for i := 0 to High(AValues) do
    Result[i] := AValues[i];
end;


function GetBooleanFilterCondition(
  const AFieldName, AValue: string; ACond: integer): string;
const
  BOOL_STR: array [boolean] of string = ('false', 'true');
  COND_OPER: array [0..13] of string = (
    '=', '<>', '>', '>=', '<', '<=', '=', '=',
    '=', '<>', '=', '<>', '=', '<>'
  );
  STR_COND = 'COALESCE(%s, false) %s %s';
var
  val: string;
begin
  Assert(
    InRange(ACond, 0, High(COND_OPER)),
    Format('Unknown filter condition: "%d"', [ACond])
  );
  case ACond of
    FILTER_COND_BLANKS:
      val := BOOL_STR[false];
    FILTER_COND_NOT_BLANKS:
      val := BOOL_STR[true];
    else
      val := BOOL_STR[StrToBool(AValue)];
  end;
  Result := Format(STR_COND, [AFieldName, COND_OPER[ACond], val]);
end;


function GetMMYYDateFilterCondition(
  const AFieldName, AValue: string; ACond: integer): string;

  function formatDate(const ADate: TDateTime): string;
  begin
    Result := FormatDateTime('yyyy-mm-dd', ADate);
  end;

  function buildCond(const ATemplate: string): string;
  var
    monStart, monEnd: string;
    dte: TDateTime;
  begin
    if MMMYYDate(AValue, dte) or TryStrToDate(AValue, dte) then begin
      monStart := formatDate(StartOfTheMonth(dte));
      monEnd := formatDate(EndOfTheMonth(dte));
    end
    else begin
      monStart := AValue;
      monEnd := AValue;
    end;
    Result := Format(ATemplate, [AFieldName, monStart, monEnd]);
  end;

begin
  case ACond of
    FILTER_COND_EQUAL, FILTER_COND_CONTAINS:
      Result := buildCond('%s BETWEEN ''%s'' AND ''%s''');
    FILTER_COND_NOT_EQUAL, FILTER_COND_NOT_CONTAINS:
      Result := buildCond('NOT (%s BETWEEN ''%s'' AND ''%s'')');
    FILTER_COND_GREATER, FILTER_COND_NOT_ENDS_ON:
      Result := buildCond('%s > ''%2:s''');
    FILTER_COND_GREATER_EQUAL, FILTER_COND_STARTS_WITH:
      Result := buildCond('%s >= ''%1:s''');
    FILTER_COND_LESS, FILTER_COND_NOT_S_WITH:
      Result := buildCond('%s < ''%1:s''');
    FILTER_COND_LESS_EQUAL, FILTER_COND_ENDS_ON:
      Result := buildCond('%s <= ''%2:s''');
    FILTER_COND_BLANKS:
      Result := buildCond('%s IS NULL');
    FILTER_COND_NOT_BLANKS:
      Result := buildCond('%s IS NOT NULL');
    else
      Assert(false, Format('Unknown filter condition: "%d"', [ACond]));
  end;
end;


function GetDateFilterCondition(
  const AFieldName, AValue: string; ACond: integer): string;
var
  val, sql: string;
  vt: TFieldType;
  d: TDateTime;

  function buildCond(const AFormatString: string): string;
  begin
    Result := Format(AFormatString, [AFieldName, val]);
  end;

begin
  val := AValue;
  // do not quote predefined date/time variables, they return SQL of proper type
  if
    not IsSQLExprVariable(val, vt, sql) or
    not (vt in [ftDate, ftTime, ftDateTime, ftTimestamp])
  then begin
    if TryStrToDate(val, d) then
      val := '''' + FormatDateTime('yyyy-mm-dd', d) + ''''
    else
      val := 'NULL';
  end;

  case ACond of
    FILTER_COND_EQUAL, FILTER_COND_CONTAINS:
      Result := buildCond('%0:s = %1:s');
    FILTER_COND_NOT_EQUAL, FILTER_COND_NOT_CONTAINS:
      Result := buildCond('%0:s <> %1:s');
    FILTER_COND_GREATER, FILTER_COND_NOT_ENDS_ON:
      Result := buildCond('%0:s > %1:s');
    FILTER_COND_GREATER_EQUAL, FILTER_COND_STARTS_WITH:
      Result := buildCond('%0:s >= %1:s');
    FILTER_COND_LESS, FILTER_COND_NOT_S_WITH:
      Result := buildCond('%0:s < %1:s');
    FILTER_COND_LESS_EQUAL, FILTER_COND_ENDS_ON:
      Result := buildCond('%0:s <= %1:s');
    FILTER_COND_BLANKS:
      Result := buildCond('%s IS NULL');
    FILTER_COND_NOT_BLANKS:
      Result := buildCond('%s IS NOT NULL');
    else
      Assert(false, Format('Unknown filter condition: "%d"', [ACond]));
  end;
end;


function GetFloatFilterCondition(
  const AFieldName, AValue: string; ACond: integer): string;
const
  TEXT_BASED_OPERATIONS = [
    FILTER_COND_STARTS_WITH, FILTER_COND_NOT_S_WITH,
    FILTER_COND_ENDS_ON, FILTER_COND_NOT_ENDS_ON,
    FILTER_COND_CONTAINS, FILTER_COND_NOT_CONTAINS
  ];
  NO_VALUE_OPERATIONS = [FILTER_COND_BLANKS, FILTER_COND_NOT_BLANKS];
  COND_OPER: array [0..13] of string = (
    '=', '<>', '>', '>=', '<', '<=', 'IS NULL', 'IS NOT NULL',
    'LIKE', 'NOT LIKE', 'LIKE', 'NOT LIKE', 'LIKE', 'NOT LIKE'
  );
  VALUE_PATTERN_STARTS_WITH = '''%s%%''';
  VALUE_PATTERN_ENDS_WITH = '''%%%s''';
  VALUE_PATTERN_CONTAINS = '''%%%s%%''';
  VALUE_PATTERN: array [0..13] of string = (
    '%s', '%s', '%s', '%s', '%s', '%s', '', '',
    VALUE_PATTERN_STARTS_WITH, VALUE_PATTERN_STARTS_WITH,
    VALUE_PATTERN_ENDS_WITH, VALUE_PATTERN_ENDS_WITH,
    VALUE_PATTERN_CONTAINS, VALUE_PATTERN_CONTAINS
  );
var
  val, sql, fldName: string;
  vt: TFieldType;
  d: double;
  isVar: boolean;
  oper: string;
begin
  fldName := AFieldName;
  if ACond in TEXT_BASED_OPERATIONS then
    fldName := Format('CAST(%s AS VARCHAR)', [AFieldName]);

  Assert(
    InRange(ACond, 0, High(COND_OPER)),
    Format('Unknown filter condition: "%d"', [ACond])
  );
  oper := COND_OPER[ACond];

  val := '';
  if not (ACond in NO_VALUE_OPERATIONS) then begin
    val := AValue;
    isVar :=
      IsSQLExprVariable(val, vt, sql) and
      (vt in [ftSmallint, ftInteger, ftWord, ftFloat, ftCurrency, ftBCD]);
    if isVar then begin
      if ACond in TEXT_BASED_OPERATIONS then
        val := 'NULL';
    end
    else begin
      if TryStrToFloat(val, d) then begin
        val := FloatToStrPoint(d);
        val := Format(VALUE_PATTERN[ACond], [val]);
      end
      else
        val := 'NULL'
    end;
  end;

  Result := JoinStrings([fldName, oper, val], ' ');
end;


function GetTimeStampDateFilterCondition(
  const AFieldName, AValue: string; ACond: integer): string;

  function formatDate(const ADate: TDateTime; AIncludeTime: boolean): string;
  begin
    if AIncludeTime then
      Result :=
        SQLTimeStampToStr(TIMESTAMP_FORMAT, DateTimeToSQLTimeStamp(ADate))
    else
      Result := FormatDateTime('yyyy-mm-dd', ADate);
  end;

  function buildCond(const ADateTemplate, ATimeStampTemplate: string): string;
  var
    startTS, endTS: string;
    dte, secDte: TDateTime;
    isTS: boolean;
    tmpl, sql: string;
    quote: boolean;
    vt: TFieldType;
    ts: TSQLTimeStamp;
  begin
    quote := false;

    if not IsSQLExprVariable(AValue, vt, sql) then
      vt := ftUnknown;

    if vt = ftDate then begin
      tmpl := ADateTemplate;
      startTS := AValue;
      // double op in case of yesterday and tomorrow
      endTS := startTS + ' + 1';
    end
    else if (vt = ftDateTime) or (vt = ftTimeStamp) then begin
      tmpl := ATimeStampTemplate;
      startTS := AValue;
      endTS := startTS;
    end
    else if TryStrToDateTime(AValue, dte) then begin
      isTS := not FloatEqual(TimeOf(dte), 0.0);
      if isTS then begin
        tmpl := ATimeStampTemplate;
        secDte := dte;
      end
      else begin
        secDte := dte + 1.0;
        tmpl := ADateTemplate;
      end;
      startTS := formatDate(dte, isTS);
      endTS := formatDate(secDte, isTS);
      quote := true;
    end
    else if
      TryStrToSQLTimeStamp(AValue, ts, LOCALE_NEUTRAL_FORMAT_SETTINGS)
    then begin
      startTS := AValue;
      endTS := AValue;
      tmpl := ATimeStampTemplate;
      quote := true;
    end
    else begin
      startTS := 'NULL';
      endTS := 'NULL';
      tmpl := ATimeStampTemplate;
    end;
    if quote then begin
      startTS := QuotedStr(startTS);
      endTS := QuotedStr(endTS);
    end;
    Result := Format(tmpl, [AFieldName, startTS, endTS]);
  end;

begin
  case ACond of
    FILTER_COND_EQUAL, FILTER_COND_CONTAINS:
      Result :=
        buildCond('%0:s >= %1:s AND %0:s < %2:s', '%0:s = %1:s');
    FILTER_COND_NOT_EQUAL, FILTER_COND_NOT_CONTAINS:
      Result :=
        buildCond('(%0:s < %1:s OR %0:s >= %2:s)', '%0:s <> %1:s');
    FILTER_COND_GREATER, FILTER_COND_NOT_ENDS_ON:
      Result := buildCond('%0:s >= %2:s', '%0:s > %1:s');
    FILTER_COND_GREATER_EQUAL, FILTER_COND_STARTS_WITH:
      Result := buildCond('%0:s >= %1:s', '%0:s >= %1:s');
    FILTER_COND_LESS, FILTER_COND_NOT_S_WITH:
      Result := buildCond('%0:s < %1:s', '%0:s < %1:s');
    FILTER_COND_LESS_EQUAL, FILTER_COND_ENDS_ON:
      Result := buildCond('%0:s < %2:s', '%0:s <= %1:s');
    FILTER_COND_BLANKS:
      Result := buildCond('%s IS NULL', '%s IS NULL');
    FILTER_COND_NOT_BLANKS:
      Result := buildCond('%s IS NOT NULL', '%s IS NOT NULL');
    else
      Assert(false, Format('Unknown filter condition: "%d"', [ACond]));
  end;
end;


function GetStringFilterCondition(
  const AFieldName, AValue: string; ACond: integer;
  AMatchCase: boolean): string;
const
  KRN_FILTER_CONDITION_SYMBOLS =
    '%s = ''%s'';%s <> ''%s'';%s > ''%s'';%s >= ''%s'';' +
    '%s < ''%s'';%s <= ''%s'';' +
    '%s IS NULL;%s IS NOT NULL;%s LIKE ''%s%%'';' +
    '%s NOT LIKE ''%s%%'';%s LIKE ''%%%s'';%s NOT LIKE ''%%%s'';' +
    '%s LIKE ''%%%s%%'';%s NOT LIKE ''%%%s%%''';
  KRN_FILTER_CONDITION_SYMBOLS_WQ =
    '%s = %s;%s <> %s;%s > %s;%s >= %s;%s < %s;%s <= %s;' +
    '%s IS NULL;%s IS NOT NULL;%s LIKE %s _ ''%%'';' +
    '%s NOT LIKE %s _ ''%%'';%s LIKE ''%%'' _ %s;%s NOT LIKE ''%%'' _ %s;' +
    '%s LIKE ''%%'' _ %s _ ''%%'';%s NOT LIKE ''%%'' _ %s _ ''%%''';
var
  term, sql: string;
  vt: TFieldType;
  isVar: boolean;
  fldName: string;
  val: string;
begin
  isVar := IsSQLExprVariable(AValue, vt, sql);
  // field is compared against string so do we
  fldName := Format('CAST(%s AS VARCHAR)', [AFieldName]);
  val := AValue;
  if not AMatchCase then begin
    fldName := 'UPPER(' + fldName + ')';
    val := UpperCase(AValue);
  end;

  if isVar then
    term := lioRead(KRN_FILTER_CONDITION_SYMBOLS_WQ, ACond)
  else
    term := lioRead(KRN_FILTER_CONDITION_SYMBOLS, ACond);

  Result := Format(term, [fldName, val]);
end;


function BinaryToHex(const ABinary; const ASize: integer): string;
begin
  SetLength(Result, ASize * 2);
  BinToHex(PChar(@ABinary), PChar(Result), ASize);
end;


procedure HexToBinary(const AHex: string; var ABinary: pointer);
var
  managesMemory: boolean;
  bufSize, newSize: integer;
begin
  Assert(not Odd(Length(AHex)));
  bufSize := Length(AHex) div 2;
  managesMemory := (ABinary = nil);
  if managesMemory then
    GetMem(ABinary, bufSize);
  try
    newSize := HexToBin(PChar(LowerCase(AHex)), ABinary, bufSize);
    Assert(bufSize = newSize);
  except
    if managesMemory then
      FreeMem(ABinary);
    raise;
  end;
end;


function ClassToStr(const AClass: TClass): string;
begin
  Result := IntToStr(integer(AClass));
end;


function GetFileList(const AMask: string; const AAttrs: integer): TStringList;
var
  sr: TSearchRec;
begin
  Result := TStringList.Create;
  try
    Result.Sorted := true;
    if FindFirst(AMask, AAttrs, sr) = 0 then
      try
        repeat
          Result.Add(sr.Name);
        until FindNext(sr) <> 0;
      finally
        FindClose(sr);
      end;
  except
    Result.Free;
    raise;
  end;
end;


procedure CloseDataSet(ADataSet: TDataSet);
begin
  if (ADataSet <> nil) then
    ADataSet.Close;
end;


function ExpandRelativePath(const ABase, APath: string): string;
var
  curDir: string;
begin
  curDir := GetCurrentDir;
  try
    SetCurrentDir(ExtractFileDir(ABase));
    Result := ExpandFileName(APath);
  finally
    SetCurrentDir(curDir);
  end;
end;


function ExpandEXERelativePath(const APath: string): string;
begin
  Result := ExpandRelativePath(ParamStr(0), APath);
end;


procedure WriteStream(ASource, ADest: TStream; const ABufSize: cardinal);
var
  buf: array of byte;
  cnt: integer;
begin
  Assert(ABufSize > 0);
  SetLength(buf, ABufSize);
  repeat
    cnt := ASource.Read(buf[0], Length(buf));
    ADest.Write(buf[0], cnt);
  until cnt < Length(buf);
end;


function IsClass(AObject: TObject; const AClasses: array of TClass): boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to High(AClasses) do
    if AObject is AClasses[i] then begin
      Result := true;
      Break;
    end;
end;


procedure DeleteDirectoryReqursive(const ADir: string; AKeepItself: boolean);
var
  sr: TSearchRec;
begin
  if FindFirst(ADir + '\*.*', faAnyFile, sr) = 0 then begin
    repeat
      if (sr.Name <> '.') and (sr.Name <> '..') then begin
        if (sr.Attr and faDirectory <> 0) then
          DeleteDirectoryReqursive(ADir + '\' + sr.Name, false)
        else
          DeleteFile(ADir + '\' + sr.Name);
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
  if not AKeepItself then
    RemoveDir(ADir);
end;


procedure SafeDeleteFile(const AFileName: string);
begin
  try
    if FileExists(AFileName) then
      if not DeleteFile(AFileName) then
        RaiseLastOSError;
  except
    on E: Exception do begin
      E.Message :=
        Format('Deleting of file "%s" failed: ', [AFileName]) + E.Message;
      Application.HandleException(E);
    end;
  end;
end;


function FastCreateDataSource(
  AOwner: TComponent; AData: TPersistent): TDataSource;
begin
  Result := TDataSource.Create(AOwner);
  Result.DataSet := TObjDataSet.Create(AOwner);
  with Result.DataSet as TObjDataSet do begin
    ObjectRef := AData;
    Open;
  end;
end;


function ConstructSQL(
  const AFieldList, ADBClassName, ACondition, AOrderBy: string;
  const ADistinct: boolean; const ASQLAlias, AJoinBlock: string): string;
const
  SQL_BASIC = 'SELECT %0:s %1:s FROM %2:s %3:s %4:s ';
  SQL_WHERE = 'WHERE %s ';
  SQL_ORDER_BY = 'ORDER BY %s';
var
  distinct: string;
begin
  if ADistinct then
    distinct := 'DISTINCT'
  else
    distinct := '';
  Result :=
    Format(
      SQL_BASIC,
      [distinct, AFieldList, ADBClassName, ASQLAlias, AJoinBlock]);
  if (ACondition <> '') then
    Result := Result + Format(SQL_WHERE, [ACondition]);
  if (AOrderBy <> '') then
    Result := Result + Format(SQL_ORDER_BY, [AOrderBy]);
end;


function ParamsToArray(AParams: TParams): TArrayOfVariant;
var
  i: integer;
begin
  SetLength(Result, AParams.Count);
  for i := 0 to AParams.Count - 1 do
    Result[i] := AParams[i].Value;
end;


function ParamsToString(AParams: TParams): string;
var
  i: integer;
  param: TParam;
  valueStr: string;
begin
  Result := '';
  if AParams = nil then
    Exit;

  for i := 0 to AParams.Count - 1 do begin
    param := AParams[i];

    valueStr := VarToStr(param.Value);
    if VarIsStr(param.Value) then
      valueStr := QuotedStr(valueStr)
    else if VarIsNull(param.Value) then
      valueStr := 'Null'
    else if VarIsEmpty(param.Value) then
      valueStr := 'Unassigned';

    Result :=
      JoinStrings(
        Result,
        Format('[%d:%s] = %s', [param.Index + 1, param.Name, valueStr]),
        #13#10
      );
  end;
end;


function GetExcelCol(AColIdx: integer): string;
begin
  Result := '';
  while AColIdx > 0 do begin
    Result := Chr(Ord('A') + (AColIdx - 1) mod 26) + Result;
    AColIdx := (AColIdx - 1) div 26;
  end;
end;


function GetExcelCell(AColIdx, ARowIdx: integer): string;
begin
  Result := GetExcelCol(AColIdx) + IntToStr(ARowIdx);
end;


procedure SaveDataSetToFile(ADataSet: TDataSet; const AFileName: string);
var
  r: string;
  i: integer;
  g: TStringList;
begin
  g := TStringList.Create;
  try
    ADataSet.Open;
    r := '';
    for i := 0 to ADataSet.FieldCount - 1 do
      r := r + ADataSet.Fields[i].FieldName + #9;
    g.Add(r);
    while not ADataSet.Eof do begin
      r := '';
      for i := 0 to ADataSet.FieldCount - 1 do
        r := r + ADataSet.Fields[i].AsString + #9;
      g.Add(r);
      ADataSet.Next;
    end;
    g.SaveToFile(AFileName);
  finally
    g.Free;
  end;
end;


procedure GridDataSetRecordDelete(AGrid: TDBGridPro; ARecNo: integer);
var
  oldRecNo: integer;
begin
  oldRecNo := AGrid.DataSet.RecNo;
  AGrid.FreezeGrid;
  AGrid.DataSet.DisableControls;
  try
    AGrid.DataSet.RecNo := ARecNo;
    AGrid.DataSet.Delete;
  finally
    AGrid.DataSet.EnableControls;
    AGrid.UnFreezeGrid(true);
  end;
  if oldRecNo < ARecNo then
    AGrid.DataSet.RecNo := oldRecNo
  else if oldRecNo > ARecNo then
    AGrid.DataSet.RecNo := oldRecNo - 1;
end;


function SwitchToUSLocale: IUSLocale;
begin
  Result := TUSLocale.Create;
end;


procedure ValueListToCollection(
  const AValueList: string; ACollection: TCoatedCollection;
  const AAttrName: string);
var
  values: TStringDynArray;
  val: string;
begin
  ACollection.LockNotifications;
  try
    ACollection.Clear;
    values := BreakString(AValueList);
    for val in values do
      ACollection.Add[AAttrName] := val;
  finally
    ACollection.UnlockNotifications(true);
  end;
end;


function CollectionToValueList(
  ACollection: TCoatedCollection; const AAttrName: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to ACollection.Count - 1 do
    Result := AddSeparated(Result, VarToStr(ACollection[i][AAttrName]), ';');
end;


procedure SaveBLOBToFile(ABlob: TBlob; const AFileName: string);
var
  fs: TFileStream;
begin
  fs := TFileStream.Create(AFileName, fmCreate);
  try
    fs.WriteBuffer(ABlob[1], Length(ABlob));
  finally
    fs.Free;
  end;
end;


function FilterChainedFields(const AFields: TStringDynArray): TStringDynArray;
var
  n: integer;
  i: integer;
  k: integer;
begin
  n := Length(AFields);
  SetLength(Result, n);
  k := 0;
  for i := 0 to n - 1 do
    if (Pos('->', AFields[i]) = 0) and (Pos('.', AFields[i]) = 0) then begin
      Result[k] := AFields[i];
      Inc(k);
    end;
  SetLength(Result, k);
end;


{ TGuard }

constructor TGuard.Create(AObject: TObject);
begin
  inherited Create;
  FObject := AObject;
end;


destructor TGuard.Destroy;
begin
  FObject.Free;
  inherited;
end;


{ TUSLocale }

constructor TUSLocale.Create;
const
  US_LONG_MONTHS: array[1..12] of string = (
    'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December'
  );
  US_SHORT_MONTHS: array[1..12] of string = (
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov',
    'Dec'
  );
var
  i: integer;
begin
  inherited;
  FDateFormat := ShortDateFormat;
  FTimeFormat := ShortTimeFormat;
  FDateSep := DateSeparator;
  FDecimalSep := DecimalSeparator;
  FThousSep := ThousandSeparator;
  FListSep := ListSeparator;
  for i := 1 to 12 do begin
    FLongMonths[i] := LongMonthNames[i];
    LongMonthNames[i] := US_LONG_MONTHS[i];
    FShortMonths[i] := ShortMonthNames[i];
    ShortMonthNames[i] := US_SHORT_MONTHS[i];
  end;
  ShortDateFormat := 'mm/dd/yyyy';
  ShortTimeFormat := 'hh:nn am/pm';
  DateSeparator := '/';
  DecimalSeparator := '.';
  ThousandSeparator := ',';
  ListSeparator := ',';
  CurrencyString := '$';
end;


destructor TUSLocale.Destroy;
var
  i: integer;
begin
  for i := 1 to 12 do begin
    LongMonthNames[i] := FLongMonths[i];
    ShortMonthNames[i] := FShortMonths[i];
  end;
  ShortDateFormat := FDateFormat;
  ShortTimeFormat := FTimeFormat;
  DateSeparator := FDateSep;
  DecimalSeparator := FDecimalSep;
  ThousandSeparator := FThousSep;
  ListSeparator := FListSep;
  inherited;
end;


{ TConditionBuilder }


procedure TConditionBuilder.Add(const ACond: string);
begin
  AddCond(ACond);
end;


procedure TConditionBuilder.Add(ABuilder: IConditionBuilder);
var
  srcCond: string;
  srcParams: TArrayOfVariant;
  n: integer;
  i: integer;
begin
  srcCond := ABuilder.Cond;
  if srcCond <> '' then
    AddCond('(' + srcCond + ')');

  srcParams := ABuilder.Params;
  n := Length(FParams);
  SetLength(FParams, n + Length(srcParams));
  for i := 0 to High(srcParams) do
    FParams[n + i] := srcParams[i];
end;


procedure TConditionBuilder.Add(const ACond: string; AParams: array of variant);
var
  n: integer;
  i: integer;
begin
  AddCond(ACond);

  n := Length(FParams);
  SetLength(FParams, n + Length(AParams));
  for i := 0 to High(AParams) do
    FParams[n + i] := AParams[i];
end;


procedure TConditionBuilder.AddCond(ACond: string);
const
  OPER_TEXT: array [TConditionOperator] of string = (' AND ', ' OR ');
begin
  if FCond <> '' then
    FCond := FCond + OPER_TEXT[FCondOper];
  FCond := FCond + ACond;
end;


procedure TConditionBuilder.AddIfNotEmpty(
  const ACond: string; const AParam: variant);
var
  n: integer;
begin
  if IsParamEmpty(AParam) then
    Exit;

  if FInlineParams and (VarType(AParam) = varUString) then
    AddCond(StringReplace(ACond, '?', QuotedStr(VarToStr(AParam)), []))
  else begin
    AddCond(ACond);
    n := Length(FParams);
    SetLength(FParams, n + 1);
    FParams[n] := AParam;
  end;
end;


procedure TConditionBuilder.Clear;
begin
  FCond := '';
  SetLength(FParams, 0);
end;


constructor TConditionBuilder.Create(
  AInlineParams: boolean; ACondOper: TConditionOperator);
begin
  inherited Create;
  FInlineParams := AInlineParams;
  FCondOper := ACondOper;
end;


function TConditionBuilder.GetCond: string;
begin
  Result := FCond;
end;


function TConditionBuilder.GetOleParams: TOleVariantDynArray;
begin
  Result := ConvertArrayVariantToOleVariant(FParams);
end;


function TConditionBuilder.GetParams: TArrayOfVariant;
begin
  Result := FParams;
end;


class function TConditionBuilder.JoinParams(
  ABuilders: array of IConditionBuilder): TArrayOfVariant;
var
  i: integer;
  j: integer;
  n: integer;
begin
  n := 0;
  for i := 0 to High(ABuilders) do
    n := n + Length(ABuilders[i].Params);
  SetLength(Result, n);

  n := 0;
  for i := 0 to High(ABuilders) do
    for j := 0 to High(ABuilders[i].Params) do begin
      Result[n] := ABuilders[i].Params[j];
      Inc(n);
    end;
end;


class function TConditionBuilder.IsParamEmpty(const AParam: variant): boolean;
begin
  Result :=
    ((VarType(AParam) = varDate) and (VarToDateTime(AParam) = 0.0)) or
    ((VarType(AParam) = varUString) and (VarToStr(AParam) = '')) or
    VarIsNull(AParam)
end;


{ TStringsKeyValueEnumerator }

constructor TStringsKeyValueEnumerator.Create(ASource: TStrings);
begin
  inherited Create;
  FSource := ASource;
  FIndex := -1;
end;


function TStringsKeyValueEnumerator.DoGetCurrent: TPair<string, string>;
begin
  Result := FCurrent;
end;


function TStringsKeyValueEnumerator.DoMoveNext: boolean;
begin
  Result := FIndex < FSource.Count - 1;
  if Result then begin
    Inc(FIndex);
    FCurrent :=
      TPair<string, string>.Create(
        FSource.Names[FIndex], FSource.ValueFromIndex[FIndex]);
  end;
end;

end.
