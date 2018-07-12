unit UJUnit;

interface

uses
  Graphics;

type
  TJUnitType = (utRed, utBlack, utYellow, utWhite);

  TJTeamType = (tRed, tBlack, tYellow, tWhite);


  TJUnit = class(TObject)
  private
    FTeamType: TJTeamType;
    FColor: TColor;
    FSelected: boolean;
  public
    constructor Create(ATeamType: TJTeamType; AColor: TColor);

    property TeamType: TJTeamType read FTeamType;
    property Color: TColor read FColor;
    property Selected: boolean read FSelected write FSelected;
  end;


  TJUnitTypeInfo = class(TObject)
  private
    FTeamType: TJTeamType;
    FColor: TColor;
  public
    constructor Create(ATeamType: TJTeamType; AColor: TColor);

    property TeamType: TJTeamType read FTeamType;
    property Color: TColor read FColor;
  end;


  TJPirate = class(TJUnit)
  end;


  TJPirateClass = class of TJPirate;


  TJPirateRed = class(TJPirate)
  public
  end;


  TJPirateBlack = class(TJPirate)
  public
  end;


  TJPirateYellow = class(TJPirate)
  public
  end;


  TJPirateWhite = class(TJPirate)
  public
  end;


implementation


{ TJUnit }

constructor TJUnit.Create(ATeamType: TJTeamType; AColor: TColor);
begin
  inherited Create;
  FTeamType := ATeamType;
  FColor := AColor;
end;


{ TJUnitTypeInfo }

constructor TJUnitTypeInfo.Create(ATeamType: TJTeamType; AColor: TColor);
begin
  inherited Create;
  FTeamType := ATeamType;
  FColor := AColor;
end;


end.
