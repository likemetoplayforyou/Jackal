// The FlipReverseRotate Library provides three functions to flip and/or
// reverse a bitmap.  You can choose which approach you'd like to use from the
// three methods to flip or reverse a bitmap:  ScanLine, CopyRect, StretchBlt.
//
// A "Flip" operation takes the top of an image to the bottom and the bottom of
// the image to the top.  It is a reflection along a horizontal line in the
// middle of an image.
//
// A "Reverse" operation takes the left of an image to the right and the right
// of the image to the left.  It is a reflection along a vertical line in the
// middle of an image.
//
// Any Flip/Reverse operation is commutative, i.e., the flip and reverse can
// be performed in any order to get the same result.  A flip followed by a
// reverse is the same as a reverse followed by a flip.
//
// A "rotate" operation spins an image 0, 90, 180 or 270 degrees around an
// axis in the center of the image.
//
// A flip/reverse operation along with a rotation is not commutative in general.
// A flip followed by a rotation will not always result in the same image as a
// rotation followed by a flip.  The rotation here ALWAYS follows any flip and/or
// reversal.
//
// The examples here are intended for use with bitmaps that have 24 bits/pixel.
// Palettes may be lost on 256-color bitmaps.
//
// Copyright (C) 1998, Earl F. Glynn.  All Rights Reserved.
// May be used freely for non-comercial use.

UNIT FlipReverseRotateLibrary;

INTERFACE

  USES
  Dialogs,
    Windows,   // TRGBTriple (put here to avoid TBitmap conflict in Implementation)
    Graphics;  // TBitmap

  // Flip/Reverse functions by Method
  FUNCTION FlipReverseScanLine(CONST Flip, Reverse:  BOOLEAN;
                               CONST Bitmap:  TBitmap):  TBitmap;

  FUNCTION FlipReverseCopyRect(CONST Flip, Reverse:  BOOLEAN;
                               CONST Bitmap:  TBitmap):  TBitmap;

  FUNCTION FlipReverseStretchBlt(CONST Flip, Reverse:  BOOLEAN;
                                 CONST Bitmap:  TBitmap):  TBitmap;

  // The Rotation function is only for the Scanline Method.
  // Note:  Windows NT supports a "plgblt" API call that can be used to rotate
  // images.
  FUNCTION RotateScanline90(CONST angle:  INTEGER;
                            CONST Bitmap:  TBitmap):  TBitmap;

IMPLEMENTATION

  USES
    Classes,    // Rect
    SysUtils;   // Exception

  CONST
    MaxPixelCount = 65536;   // or some other arbitrarily large value

  TYPE
    EBitmapError = CLASS(Exception);
    TRGBArray    = ARRAY[0..MaxPixelCount-1] OF TRGBTriple;
    pRGBArray    = ^TRGBArray;


  //////////////////////////////////////////////////////////////////////////////

  FUNCTION FlipReverseScanLine(CONST Flip, Reverse:  BOOLEAN;
                               CONST Bitmap:  TBitmap):  TBitmap;
  VAR
    i     :  INTEGER;
    j     :  INTEGER;
    RowIn :  pRGBArray;
    RowOut:  pRGBArray;
  BEGIN
    IF   Bitmap.PixelFormat <> pf24bit
    THEN RAISE EBitmapError.Create('Can Flip/Reverse only 24-bit bitmap');

    RESULT := TBitmap.Create;
    RESULT.Width       := Bitmap.Width;
    RESULT.Height      := Bitmap.Height;
    RESULT.PixelFormat := Bitmap.PixelFormat;

    FOR j := 0 TO Bitmap.Height-1 DO
    BEGIN
      RowIn := Bitmap.Scanline[j];
      IF   Flip
      THEN RowOut := RESULT.Scanline[Bitmap.Height - 1 - j]
      ELSE RowOut := RESULT.Scanline[j];

      // Optimization technique:  Use two FOR loops so IF is outside of inner loop
      IF   Reverse
      THEN BEGIN
        FOR i := 0 TO Bitmap.Width-1 DO
          RowOut[i] := RowIn[Bitmap.Width-1-i]
      END
      ELSE BEGIN
        FOR i := 0 TO Bitmap.Width-1 DO
          RowOut[i] := RowIn[i]
      END

    END
  END {FlipReverseScanLine};


  //////////////////////////////////////////////////////////////////////////////

  // This function implements a suggestion by David Ullrich in a July 25, 1997
  // post to comp.lang.pascal.delphi.misc.
  //
  // The Graphics.PAS unit shows that CopyRect calls the Windows StretchBlt API
  // function.
  FUNCTION FlipReverseCopyRect(CONST Flip, Reverse:  BOOLEAN;
                               CONST Bitmap:  TBitmap):  TBitmap;
    VAR
      Bottom:  INTEGER;
      Left  :  INTEGER;
      Right :  INTEGER;
      Top   :  INTEGER;
  BEGIN
    RESULT := TBitmap.Create;
    RESULT.Width       := Bitmap.Width;
    RESULT.Height      := Bitmap.Height;
    RESULT.PixelFormat := Bitmap.PixelFormat;

    // Flip Top to Bottom
    IF   Flip
    THEN BEGIN
      // Unclear why extra "-1" is needed here.
      Top    := Bitmap.Height-1;
      Bottom := -1
    END
    ELSE BEGIN
      Top    := 0;
      Bottom := Bitmap.Height
    END;

    // Reverse Left to Right
    IF   Reverse
    THEN BEGIN
      // Unclear why extra "-1" is needed here.
      Left  := Bitmap.Width-1;
      Right := -1;
    END
    ELSE BEGIN
      Left  := 0;
      Right := Bitmap.Width;
    END;

    RESULT.Canvas.CopyRect(Rect(Left,Top, Right,Bottom),
                           Bitmap.Canvas,
                           Rect(0,0, Bitmap.Width,Bitmap.Height));
  END {FlipReverseCopyRect};


  //////////////////////////////////////////////////////////////////////////////

  FUNCTION FlipReverseStretchBlt(CONST Flip, Reverse:  BOOLEAN;
                                 CONST Bitmap:  TBitmap):  TBitmap;
    VAR
      Bottom:  INTEGER;
      Left  :  INTEGER;
      Right :  INTEGER;
      Top   :  INTEGER;
  BEGIN
    RESULT := TBitmap.Create;
    RESULT.Width       := Bitmap.Width;
    RESULT.Height      := Bitmap.Height;
    RESULT.PixelFormat := Bitmap.PixelFormat;

    // Flip Top to Bottom
    IF   Flip
    THEN BEGIN
      // Unclear why extra "-1" is needed here.
      Top    := Bitmap.Height-1;
      Bottom := -1
    END
    ELSE BEGIN
      Top    := 0;
      Bottom := Bitmap.Height
    END;

    // Reverse Left to Right
    IF   Reverse
    THEN BEGIN
      // Unclear why extra "-1" is needed here.
      Left  := Bitmap.Width-1;
      Right := -1;
    END
    ELSE BEGIN
      Left  := 0;
      Right := Bitmap.Width;
    END;

    StretchBlt(RESULT.Canvas.Handle, Left, Top, Right-Left, Bottom-Top,
               Bitmap.Canvas.Handle,
               0,0, Bitmap.Width, Bitmap.Height, cmSrcCopy);
  END {FlipReverseStretchBlt};


  //////////////////////////////////////////////////////////////////////////////

  // Rotate 24-bits/pixel Bitmap any multiple of 90 degrees.
  FUNCTION RotateScanLine90(CONST angle:  INTEGER;
                            CONST Bitmap:  TBitmap):  TBitmap;

    // These four internal functions parallel the four cases in rotating a
    // bitmap using the Pixels property.  See the RotatePixels example on
    // the Image Processing page of efg's Computer Lab for an example of the
    // use of the Pixels property (which is very slow).

    // A Bitmap.Assign could be used for a simple copy.  A complete example
    // using ScanLine is included here to help explain the other three cases.
    FUNCTION SimpleCopy:  TBitmap;
      VAR
        i     :  INTEGER;
        j     :  INTEGER;
        rowIn :  pRGBArray;
        rowOut:  pRGBArray;
    BEGIN
      RESULT := TBitmap.Create;
      RESULT.Width  := Bitmap.Width;
      RESULT.Height := Bitmap.Height;
      RESULT.PixelFormat := Bitmap.PixelFormat;    // only pf24bit for now

      // Out[i, j] = In[i, j]

      FOR  j := 0 TO Bitmap.Height - 1 DO
      BEGIN
        rowIn  := Bitmap.ScanLine[j];
        rowOut := RESULT.ScanLine[j];

        // Could optimize the following by using a function like CopyMemory
        // from the Windows unit.
        FOR i := 0 TO Bitmap.Width - 1 DO
        BEGIN
          // Why does this crash with RowOut[i] := RowIn[i]?  Alignment?
          // Use this longer form as workaround.
          WITH rowOut[i] DO
          BEGIN
            rgbtRed   := rowIn[i].rgbtRed;
            rgbtGreen := rowIn[i].rgbtGreen;
            rgbtBlue  := rowIn[i].rgbtBlue;
          END
        END
      END
    END {SimpleCopy};


    FUNCTION Rotate90DegreesCounterClockwise:  TBitmap;
       VAR
        i     :  INTEGER;
        j     :  INTEGER;
        rowIn :  pRGBArray;
    BEGIN
      RESULT := TBitmap.Create;
      RESULT.Width  := Bitmap.Height;
      RESULT.Height := Bitmap.Width;
      RESULT.PixelFormat := Bitmap.PixelFormat;    // only pf24bit for now

      // Out[j, Right - i - 1] = In[i, j]
      FOR  j := 0 TO Bitmap.Height - 1 DO
      BEGIN
        rowIn  := Bitmap.ScanLine[j];
        FOR i := 0 TO Bitmap.Width - 1 DO
          pRGBArray(RESULT.ScanLine[Bitmap.Width - i - 1])[j] := rowIn[i]
      END
    END {Rotate90DegreesCounterClockwise};


    // Could use Rotate90DegreesCounterClockwise twice to get a
    // Rotate180DegreesCounterClockwise.  Rotating 180 degrees is the same
    // as a Flip and Reverse
    FUNCTION Rotate180DegreesCounterClockwise:  TBitmap;
      VAR
        i     :  INTEGER;
        j     :  INTEGER;
        rowIn :  pRGBArray;
        rowOut:  pRGBArray;
    BEGIN
      RESULT := TBitmap.Create;
      RESULT.Width  := Bitmap.Width;
      RESULT.Height := Bitmap.Height;
      RESULT.PixelFormat := Bitmap.PixelFormat;    // only pf24bit for now

      // Out[Right - i - 1, Bottom - j - 1] = In[i, j]
      FOR  j := 0 TO Bitmap.Height - 1 DO
      BEGIN
        rowIn  := Bitmap.ScanLine[j];
        rowOut := RESULT.ScanLine[Bitmap.Height - j - 1];
        FOR i := 0 TO Bitmap.Width - 1 DO
          rowOut[Bitmap.Width - i - 1] := rowIn[i]
      END

    END {Rotate180DegreesCounterClockwise};


    // Could use Rotate90DegreesCounterClockwise three times to get a
    // Rotate270DegreesCounterClockwise
    FUNCTION Rotate270DegreesCounterClockwise:  TBitmap;
      VAR
        i    :  INTEGER;
        j    :  INTEGER;
        rowIn:  pRGBArray;
    BEGIN
      RESULT := TBitmap.Create;
      RESULT.Width  := Bitmap.Height;
      RESULT.Height := Bitmap.Width;
      RESULT.PixelFormat := Bitmap.PixelFormat;    // only pf24bit for now

      // Out[Bottom - j - 1, i] = In[i, j]
      FOR  j := 0 TO Bitmap.Height - 1 DO
      BEGIN
        rowIn  := Bitmap.ScanLine[j];
        FOR i := 0 TO Bitmap.Width - 1 DO
          pRGBARray(RESULT.Scanline[i])[Bitmap.Height - j - 1] := rowIn[i]
      END
    END {Rotate270DegreesCounterClockwise};


  BEGIN
    IF   Bitmap.PixelFormat <> pf24bit
    THEN RAISE EBitmapError.Create('Can Rotate90 only 24-bit bitmap');

    IF   (angle >= 0) AND (angle MOD 90 <> 0)
    THEN RAISE EBitmapError.Create('Rotate90:  Angle not positive multiple of 90 degrees');

    CASE (angle DIV 90) MOD 4 OF
      0:  RESULT := SimpleCopy;
      1:  RESULT := Rotate90DegreesCounterClockwise;  // Anticlockwise for the Brits
      2:  RESULT := Rotate180DegreesCounterClockwise;
      3:  RESULT := Rotate270DegreesCounterClockwise
      ELSE
        RESULT := NIL    // avoid compiler warning
    END;

  END {RotateScanline90};

END.
