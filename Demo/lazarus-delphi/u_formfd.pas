unit u_formfd;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  FDTreeView;
type TIndividu = record
      Nom : String;
      Prenom : String;
      Naissance : String;
      Sexe : Byte;
      Deces : String;
     end;

const Arbre : Array [ 0..2 ] of TIndividu = ((Nom:'Giroux';Prenom:'Mathilde';Naissance:'16/12/1995';Sexe:2),
                                             (Nom:'Giroux';Prenom:'Matthieu';Naissance:'16/12/1975';Sexe:1),
                                             (Nom:'Giroux';Prenom:'Sandrine';Naissance:'16/12/1976';Sexe:2));

  { Tformfd }
type
  INode = class
    public
      Nom : String;
      Prenom : String;
      Naissance : String;
      Sexe : Byte;
      Deces : String;
  End;
  Tformfd = class(TForm)
    FDTreeView: TFDTreeView;
    procedure FDTreeViewPaintNode(const CustomfdTree: TObject;
      const ANode: TFDNode; const ACanvas: TCanvas; const PaintRect : TRect);
  private
    { private declarations }
  public
    { public declarations }
    constructor Create ( Aowner:TComponent ); override;
  end; 

var
  formfd: Tformfd;

implementation

{ Tformfd }

constructor Tformfd.Create(Aowner: TComponent);
var ainode : inode ;
    node : TFDNode;
    aparent : TFDNode;
    n : integer;
begin
  inherited Create(Aowner);
  fdtreeview.AcceptRepaint := False;
  fdtreeview.Clear;
  aparent := nil;
  for n := 0 to high ( Arbre ) do
    Begin
      Node  := FDTreeview.AddNode ( aparent );
      ainode := inode.Create;
      ainode.nom := Arbre [ n ].nom;
      ainode.prenom := Arbre [ n ].prenom;
      ainode.naissance := Arbre [ n ].naissance;
      ainode.deces := Arbre [ n ].deces;
      ainode.sexe := Arbre [ n ].sexe;
      Node.AObject := ainode ;
      Node.Width  :=  161;
      Node.height :=  50;
      if ainode.Sexe = 1 then
        Node.Color := $00F6CA92
      else
      if ainode.Sexe = 2 then
        begin
          Node.Color :=  $00B5A7F2;
          //node.Shape := shRoundRect;
        end;
      if n = 0 then
        Begin
          aparent := Node;
        end;
    end;
  fdtreeview.AcceptRepaint := True;
end;

procedure Tformfd.FDTreeViewPaintNode(const CustomfdTree: TObject;
  const ANode: TFDNode; const ACanvas: TCanvas; const PaintRect : TRect);
var
  s, sPrenom: string;
  y: integer;
  Individu : Inode ;
begin
  if ANode.AObject <> nil then
    begin
//      R := Rect;
      Individu := (INode(ANode.AObject));
      //node.Caption := Individu.Prenom;
      aCanvas.Pen.Color := clBlack;
      if Individu.Sexe = 1 then
        aCanvas.Brush.Color := $00F6CA92
      else
      if Individu.Sexe = 2 then
        begin
        aCanvas.Brush.Color :=  $00B5A7F2;
          //node.Shape := shRoundRect;
        end;
//      aCanvas.FillRect(PaintRect);
      aCanvas.Brush.Style := bsClear;
      aCanvas.TextRect(PaintRect, PaintRect.left + 2, PaintRect.top, Individu.Nom);

      sPrenom := Individu.PreNom;
      if Length(sPrenom) > 0 then
        begin
          if Length(sPrenom) > 25 then
            sPrenom := Copy(sPrenom, 0, 25) + '...';
        end;

      aCanvas.TextRect(PaintRect, PaintRect.left + 2, PaintRect.top + 15, sPrenom);
      y := PaintRect.Top + 30;

      s := trim(Individu.Naissance);
      if s <> '' then
        begin
          s := '° ' + s;
          aCanvas.TextRect(PaintRect, PaintRect.left + 2, y, s);
          y := y + 15;
        end;

      s := trim(Individu.Deces);
      if s <> '' then
        begin
          s := '+ ' + s;
          aCanvas.TextRect(PaintRect, PaintRect.left + 2, y, s);
        end;
    end;


  //  Node.ChildAlign := caright;
end;



initialization
  {$I u_formfd.lrs}

end.

