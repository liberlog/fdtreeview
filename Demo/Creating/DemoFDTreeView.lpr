program DemoFDTreeView;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

uses
  Forms,
  LCLIntf, Interfaces,
  MainForm in 'MainForm.pas' {DlgMainForm},
  About in 'About.pas' {DlgAbout},
  Miscel in 'Miscel.pas',
  SetNodeProperties in 'SetNodeProperties.pas' {DlgSetNodeProperties},
  Preferences in 'Preferences.pas', lfdtreeview, extcopy, rxnew {DlgPreferences};

{$IFNDEF FPC}
{$R *.RES}
{$ENDIF}

begin
  Application.Initialize;
  Application.CreateForm(TDlgMainForm, DlgMainForm);
  Application.Run;
end.
