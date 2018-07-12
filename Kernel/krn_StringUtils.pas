unit krn_StringUtils;

interface

uses
  Types, Generics.Defaults, Generics.Collections;

type
  TSetOfChar = set of ansichar;


  TCaseInsensitiveStringComparer = class(TEqualityComparer<string>)
  public
    function Equals(const ALeft, ARight: string): boolean; override;
    function GetHashCode(const AValue: string): integer; override;
  end;


  // O(n)
  procedure AppendStrToArray(
    var AArray: TStringDynArray; const AString: string);
  // O(m * n)
  procedure AppendStrsToArray(
    var AArray: TStringDynArray; const AStrings: array of string);

  function BackPos(const Substr, S: string): integer;

  function ConvertStringToProper(const AStr: string): string;

  function FormatPhone(const APhone: string): string;

  function UpperCaseFirstLetter(
    const ASentence: string; ASeps: TSetOfChar = [#0..#32]): string;

implementation

uses
  SysUtils, Windows;


procedure AppendStrToArray(var AArray: TStringDynArray; const AString: string);
var
  i, l: integer;
begin
  l := Length(AArray);
  for i := 0 to l - 1 do
    if (AArray[i] = AString) then
      Exit;

  SetLength(AArray, l + 1);
  AArray[l] := AString;
end;


procedure AppendStrsToArray(
  var AArray: TStringDynArray; const AStrings: array of string);
var
  i: integer;
begin
  for i := 0 to High(AStrings) do
    AppendStrToArray(AArray, AStrings[i]);
end;


function BackPos(const Substr, S: string): integer;
var
  i, j: integer;
begin
  Result := 0;
  if (Substr = '') or (S = '') then
    Exit;
  for i := Length(S) - Length(Substr) + 1 downto 1 do begin
    Result := i;
    for j := 1 to Length(Substr) do
      if S[i + j - 1] <> Substr[j] then begin
        Result := 0;
        Break;
      end;
    if Result > 0 then
      Break;
  end;
end;


function ConvertStringToProper(const AStr: string): string;
var
  i: integer;
  b: boolean;
begin
  Result := AStr;
  b := false;
  for i := 1 to Length(Result) do
    if IsCharAlphaNumeric(Result[i]) then begin
      if not b then
        Result[i] := AnsiUpperCase(Result[i])[1];
      b := true;
    end
    else
      b := false;
end;


function FormatPhone(const APhone: string): string;
begin
  Result := APhone;
  while (Length(Result) < 10) do
    Result := ' ' + Result;
  Result :=
    '(' + Copy(Result, 1, 3) + ') ' + Copy(Result, 4, 3) + '-' +
    Copy(Result, 7, 4);
end;


function UpperCaseFirstLetter(
  const ASentence: string; ASeps: TSetOfChar = [#0..#32]): string;
var
  i: integer;
  lastWasSep: boolean;
begin
  Result := AnsiLowerCase(ASentence);
  lastWasSep := true;
  for i := 1 to Length(ASentence) do
    if (AnsiChar(ASentence[i]) in ASeps) then
      lastWasSep := true
    else if lastWasSep then begin
      Result[i] := AnsiUpperCase(Result[i])[1];
      lastWasSep := false;
    end;
end;


{ TCaseInsensitiveStringComparer }

function TCaseInsensitiveStringComparer.Equals(
  const ALeft, ARight: string): boolean;
begin
  Result := SameText(ALeft, ARight);
end;


function TCaseInsensitiveStringComparer.GetHashCode(
  const AValue: string): integer;
var
  value: string;
begin
  value := LowerCase(AValue);
  Result := BobJenkinsHash(PChar(value)^, SizeOf(Char) * Length(value), 0);
end;


end.
