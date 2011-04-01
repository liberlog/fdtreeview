unit About;

{$IFDEF FPC}
{$MODE Delphi}
{$R *.lfm}
{$ELSE}
{$R *.DFM}
{$ENDIF}

interface

uses
{$IFDEF FPC}
  LCLIntf,
{$ENDIF}
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
     Buttons, ExtCtrls, registry{, jpeg};

type
  TDlgAbout = class(TForm)
    Panel1: TPanel;
    ProductName: TLabel;
    OKButton: TButton;
    LabelVersion: TLabel;
    LabelEMail: TLabel;
    Label1: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure LabelEMailClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
{$IFNDEF FPC}
uses
  ShellApi;
{$ENDIF}

procedure TDlgAbout.OKButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TDlgAbout.LabelEMailClick(Sender: TObject);
begin
  {$IFNDEF FPC}
  Shellexecute(0, nil, pchar('mailto:fdeport@free.fr'), nil, nil, 0);
  {$ENDIF}
end;

procedure TDlgAbout.Label1Click(Sender: TObject);
begin
  {$IFNDEF FPC}
  Shellexecute(0, nil, pchar('http://fdeport.free.fr'), nil, nil, 0);
  {$ENDIF}
end;


end.
