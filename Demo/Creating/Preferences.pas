unit Preferences;

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
{$ELSE}
  RXSpin, Mask,
{$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, Spin;

type

  { TDlgPreferences }

  TDlgPreferences = class(TForm)
    Panel1: TPanel;
    BtnOk: TBitBtn;
    BtnCancel: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    LabelEspacementH: TLabel;
    LabelEspacementV: TLabel;
    BtnFeuille1: TButton;
    EditHauteur: {$IFDEF FPC}TSpinEdit{$ELSE}TRxSpinEdit{$ENDIF};
    EditLargeur: {$IFDEF FPC}TSpinEdit{$ELSE}TRxSpinEdit{$ENDIF};
    BtnFeuille2: TButton;
    BtnFeuille3: TButton;
    EditHIdent: {$IFDEF FPC}TSpinEdit{$ELSE}TRxSpinEdit{$ENDIF};
    EditVIdent: {$IFDEF FPC}TSpinEdit{$ELSE}TRxSpinEdit{$ENDIF};
    procedure FormActivate(Sender: TObject);
    procedure EditLargeurChange(Sender: TObject);
    procedure CBNoMaxClick(Sender: TObject);
  private
    FTreeButtonHeight: Integer;
    FTreeButtonWidth: Integer;
    FTreeMargin: Integer;
    FTreeHIdent: Integer;
    FAffichageV: Boolean;
    procedure SetComponentsValues;
    procedure SetValuesFromComponents;
    procedure SetComponents;
  protected

  public
    property TreeButtonHeight: Integer read FTreeButtonHeight write FTreeButtonHeight;
    property TreeButtonWidth: Integer read FTreeButtonWidth write FTreeButtonWidth;
    property TreeMargin: Integer read FTreeMargin write FTreeMargin;
    property AffichageV: Boolean write FAffichageV;
  end;

implementation


var
  bSetComponentsValues: Boolean;
procedure TDlgPreferences.SetComponentsValues;
begin
  bSetComponentsValues := True;
  try
    EditHauteur.Value := FTreeButtonHeight;
    EditLargeur.Value := FTreeButtonWidth;
    EditHIdent.Value  := FTreeHIdent;
    EditVIdent.Value  := FTreeMargin;
  finally
    bSetComponentsValues := False;
  end;
end;

procedure TDlgPreferences.SetValuesFromComponents;
begin
  if not bSetComponentsValues then begin
    FTreeButtonHeight := Trunc(EditHauteur.Value);
    FTreeButtonWidth  := Trunc(EditLargeur.Value);
    FTreeHIdent       := Trunc(EditHIdent.Value);
    FTreeMargin       := Trunc(EditVIdent.Value);
    SetComponents;
  end;
end;

procedure TDlgPreferences.SetComponents;
begin
  LabelEspacementH.Enabled := not FAffichageV;
  EditHIdent.Enabled := not FAffichageV;
  BtnFeuille2.Visible := not FAffichageV;
  LabelEspacementV.Enabled := FAffichageV;
  EditVIdent.Enabled := FAffichageV;
  BtnFeuille3.Visible := FAffichageV;

  BtnFeuille1.Height := FTreeButtonHeight;
  BtnFeuille1.Width  := FTreeButtonWidth;
  BtnFeuille2.Height := FTreeButtonHeight;
  BtnFeuille2.Width  := FTreeButtonWidth;
  BtnFeuille3.Height := FTreeButtonHeight;
  BtnFeuille3.Width  := FTreeButtonWidth;
  BtnFeuille2.Left   := BtnFeuille1.Left + FTreeHIdent;
  BtnFeuille3.Top   := BtnFeuille1.Top + FTreeMargin;
end;


{**********************************************************}
{*                         Interface                      *}
{**********************************************************}
procedure TDlgPreferences.FormActivate(Sender: TObject);
begin
  SetComponentsValues;
  SetComponents;
end;

procedure TDlgPreferences.EditLargeurChange(Sender: TObject);
begin
  SetValuesFromComponents;
end;

procedure TDlgPreferences.CBNoMaxClick(Sender: TObject);
begin
  SetComponents;
end;

end.