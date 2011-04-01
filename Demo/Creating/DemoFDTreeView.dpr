program DemoFDTreeView;

uses
  Forms,
  Windows,
  MainForm in 'MainForm.pas' {DlgMainForm},
  About in 'About.pas' {DlgAbout},
  Miscel in 'Miscel.pas',
  SetNodeProperties in 'SetNodeProperties.pas' {DlgSetNodeProperties},
  Preferences in 'Preferences.pas' {DlgPreferences};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDlgMainForm, DlgMainForm);
  Application.Run;
end.
