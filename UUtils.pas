unit UUtils;

interface

uses
  Controls, Graphics;

type
  TBitmapCopyProc = function(const ABitmap: TBitmap): TBitmap;

  function RotateBitmap90(const ABitmap: TBitmap): TBitmap;
  function RotateBitmap180(const ABitmap: TBitmap): TBitmap;
  function RotateBitmap270(const ABitmap: TBitmap): TBitmap;

  procedure CopyImageList(
    ASource, ADest: TImageList; ASourceImageCopyProc: TBitmapCopyProc = nil);

implementation

uses
  Types,
  FlipReverseRotateLibrary;

function RotateBitmap90(const ABitmap: TBitmap): TBitmap;
begin
  Result := RotateScanline90(90, ABitmap);
end;


function RotateBitmap180(const ABitmap: TBitmap): TBitmap;
begin
  Result := RotateScanline90(180, ABitmap);
end;


function RotateBitmap270(const ABitmap: TBitmap): TBitmap;
begin
  Result := RotateScanline90(270, ABitmap);
end;


procedure CopyImageList(
  ASource, ADest: TImageList; ASourceImageCopyProc: TBitmapCopyProc);
var
  imgSrc, imgDst: TBitmap;
  imgSrcCopy: TBitmap;
  i: integer;
  rct: TRect;
begin
  ADest.Clear;

  rct := Rect(0, 0, ADest.Width, ADest.Height);

  imgSrc := nil;
  imgDst := nil;
  imgSrcCopy := nil;
  try
    imgSrc := TBitmap.Create;
    imgDst := TBitmap.Create;

    imgSrc.PixelFormat := pf24bit;
    imgDst.PixelFormat := pf24bit;

    imgDst.Width := ADest.Width;
    imgDst.Height := ADest.Height;
    for i := 0 to ASource.Count - 1 do begin
      imgDst.Canvas.FillRect(rct);
      ASource.GetBitmap(i, imgSrc);
      if Assigned(ASourceImageCopyProc) then begin
        imgSrcCopy := ASourceImageCopyProc(imgSrc);
        try
          imgDst.Canvas.StretchDraw(rct, imgSrcCopy);
        finally
          imgSrcCopy.Free;
        end;
      end
      else
        imgDst.Canvas.StretchDraw(rct, imgSrc);
      ADest.Add(imgDst, nil);
    end;
  finally
    imgSrc.Free;
    imgDst.Free;
  end;
end;


end.
