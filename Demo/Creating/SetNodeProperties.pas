unit SetNodeProperties;

{$IFDEF FPC}
{$MODE Delphi}
{$R *.lfm}
{$ELSE}
{$R *.DFM}
{$ENDIF}

interface

uses
{$IFDEF FPC}
  LCLIntf, LResources,
{$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, FDTreeView, ExtDlgs, Spin;

type

  { TDlgSetNodeProperties }

  TDlgSetNodeProperties = class(TForm)
    Panel1: TPanel;
    BtnOk: TBitBtn;
    BtnCancel: TBitBtn;
    EditCaption: TEdit;
    Label1: TLabel;
    BtnFontCaption: TBitBtn;
    FontDialog1: TFontDialog;
    BtnGlyph: TBitBtn;
    Image1: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    EditNumGlyph: TSpinEdit;
    Label2: TLabel;
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnFontCaptionClick(Sender: TObject);
    procedure BtnGlyphClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
  private
    procedure SetNode(Value: TFDNode);
  public
    procedure SetNodeProperties(aNode: TFDNode);
    property Node: TFdNode Write SetNode;
  end;
var FOkClick : LongInt;

implementation


procedure TDlgSetNodeProperties.SetNodeProperties(aNode: TFDNode);
begin
  { Comme le TFDNode est un dérivé de TSpeedButton on peut utiliser toutes les
    propriétés de TSpeedButton (Caption, color, Font, Glyph, etc...
    Dans cet exemple je n'utilise que Caption et Font

    A noter que TFDNode possède en plus une propriété aObject de type TObject
    Cette propriété permet de lier un objet quelconque à un noeud.
    Important : Lors de le destruction d'un Noeud celui ci detruit l'objet
    et remet le pointeur de l'objet à Nil }
  With aNode do begin
    Caption := EditCaption.Text;
    Font.Assign(BtnFontCaption.Font);
    if not Image1.Picture.Bitmap.Empty then
      Glyph.Assign(Image1.Picture);
    NumGlyphs := EditNumGlyph.Value;
  end;
end;

procedure TDlgSetNodeProperties.SetNode(Value: TFDNode);
begin
  With Value do begin
    EditCaption.Text := Caption;
    BtnFontCaption.Font.Assign(Font);
    Image1.Picture.Assign(Glyph);
    EditNumGlyph.Value := NumGlyphs;
  end;
end;

procedure TDlgSetNodeProperties.BtnFontCaptionClick(Sender: TObject);
begin
  FontDialog1.Options := FontDialog1.Options - [fdApplyButton];
  FontDialog1.Font.Assign(BtnFontCaption.Font);
  if FontDialog1.Execute then BtnFontCaption.Font.Assign(FontDialog1.Font);
end;

procedure TDlgSetNodeProperties.BtnCancelClick(Sender: TObject);
begin
  FOkClick := mrCancel;
  Close;
end;

procedure TDlgSetNodeProperties.BtnGlyphClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
end;

procedure TDlgSetNodeProperties.BtnOkClick(Sender: TObject);
begin
  FOkClick := mrOk;
  Close;
end;
end.
