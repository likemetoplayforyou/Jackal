program Jackal;

uses
  Forms,
  UMain in 'UMain.pas' {frmMain},
  UCellMatrix in 'UCellMatrix.pas',
  UJCellMatrix in 'UJCellMatrix.pas',
  UJCell in 'UJCell.pas',
  UUtils in 'UUtils.pas',
  FlipReverseRotateLibrary in 'Libs\FlipReverseRotateLibrary.pas',
  UJConsts in 'UJConsts.pas',
  UJVDM in 'UJVDM.pas' {JVDM},
  UJCellBitmapContainer in 'UJCellBitmapContainer.pas',
  krn_Containers in 'Kernel\krn_Containers.pas',
  krn_StringUtils in 'Kernel\krn_StringUtils.pas',
  UJUnit in 'UJUnit.pas',
  UJRegister in 'UJRegister.pas',
  UJEnvironment in 'UJEnvironment.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
