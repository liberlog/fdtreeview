unit FDTreeView;

{$IFDEF FPC}
{$Mode Delphi}
{$ENDIF}

{
fdtreeview GNU GPL Version 1.0
Portage to LAZARUS : Matthieu GIROUX - www.liberlog.fr
Porting old TFDTreeview and setting object compliant

Integrated in Freelogy Project
This component is member of Freelogy Project
http://freelogy.sourceforge.net
}

interface
uses
  Classes, Buttons, Controls, StdCtrls, ExtCtrls, Graphics, Menus,
{$IFNDEF FPC}
  Types,
{$ENDIF}
  SysUtils, Dialogs;

type
  TTreeOrientation = (toHorizontal, toVertical);
  TNodeAlign = (naNormal, naInvert);
  TNodeType = (ntDirect,ntPlain);

  TFDTreeView = Class;
  TFDNode = Class;
  TNodeNotifyEvent = procedure(Sender: TFDNode) of object;
  TNodeMouseEvent = procedure (Sender: TFDNode; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
  EOnPaintNode = procedure  (const CustomfdTree: TObject; const ANode : TFDNode ; const ACanvas : TCanvas  ; const PaintRect : TRect ) of object;

  { TCustomFDTree }

  TCustomFDTree = Class(TCustomPanel)
  public
    procedure DoOnPaintNode ( const ANode : TFDNode ; const ACanvas : TCanvas  ; const PaintRect : TRect); virtual; abstract;
    function IsPaintNodeEvent : Boolean; virtual; abstract;
    property Canvas;
  end;

  { TFDNode }

  TFDNode = Class(TSpeedButton)
  private
    FLevel: Integer;
    FParentTree: TFDTreeView;
    FParentNode: TFDNode;
    FChildList: TList;
    FNodeGetFocus: TNodeNotifyEvent;
    FAObject: TObject;
    function GetLevel: Integer;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure SendToScreen( const ALevel: Integer);
    procedure DrawParentLink();
    function AddChild(MyParentTree: TFDTreeView; AParentNode: TFDNode): TFDNode;
    procedure Clear;
    property ChildList: TList Read FChildList;
    property ParentTree: TFDTreeView Read FParentTree Write FParentTree;
    property ParentNode: TFDNode Read FParentNode Write FParentNode;
    property Level: Integer Read GetLevel Write FLevel;
    property AObject: TObject Read FAObject Write FAObject;
    property OnNodeGetFocus: TNodeNotifyEvent Read FNodeGetFocus Write FNodeGetFocus;
  end;

  { TFDTreeView }

  TFDTreeView = Class(TCustomFDTree)
  private
    FOnPaintNode : EOnPaintNode;
    FNodeType : TNodeType;
    FAutoEnlarge,
    FDestroyingRootNode : Boolean;
    FRootNode : TFDNode;
    FNodeList: TList;
    FSelectedNode: TFDNode;
    FLabelInfo: TLabel;
    FLineColor: TColor;
    FBackColor: TColor;
    FTotalMaxCount : Longint;
    FMargin: Integer;
    FNodeMargin: Integer;
    FTreeOrientation: TTreeOrientation;
    FNodeWidth: Integer;
    FNodeHeight: Integer;
    FNodeAlign: TNodeAlign;
    FNodePopupMenu: TPopupMenu;
    FNodeDefaultFont: TFont;
    FAcceptRepaint: Boolean;
    FNodeClick: TNodeNotifyEvent;
    FNodeDblClick: TNodeNotifyEvent;
    FNodeMouseDown: TNodeMouseEvent;
    FSelectedNodeChange: TNodeNotifyEvent;
    procedure NodeDblClickEvent(Sender: TObject);
    procedure SetLineColor(const Value: TColor);
    procedure SetBackColor(const Value: TColor);
    procedure SetIdent(const Value: Integer);
    procedure SetTreeOrientation(const Value: TTreeOrientation);
    procedure SetNodeAlign(const Value: TNodeAlign);
    procedure SetNodePopupMenu(const Value: TPopupMenu);
    procedure SetNodeWidth(const Value: Integer);
    procedure SetNodeMargin(const Value: Integer);
    procedure SetNodeHeight(const Value: Integer);
    procedure SetNodeDefaultFont(const Value: TFont);
    function GetNodeCount: Integer;
    procedure SetAcceptRepaint ( const Value : Boolean );
    procedure SetAutoEnlarge ( const Value : Boolean );
    function setSortList(const ALevel : Integer ; var CountedChildNodes, CountedNoChildParentNodes: Integer): TList;
  protected
    procedure SortAddrNodes( const ANodeList: TList; const ANode: TFDNode); overload;
    procedure setTotalMaxCount;virtual;
    procedure SortAddrNodes; overload; virtual;
    procedure SortNodes; virtual;
    procedure Paint; override;
    procedure Resize; override;
    procedure NodeMouseDownEvent( Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);virtual;
    procedure NodeGetFocus( Sender: TFDNode); virtual;
    procedure NodeClickEvent( Sender: TObject); virtual;
    function GetNode( Index: Integer): TFDNode; virtual;
    procedure Enlarge; virtual;
  public
    property TotalMaxCount : Longint read FTotalMaxCount;
    property DestroyingRootNode : Boolean read FDestroyingRootNode;
    function GetMaxLevel: Integer; virtual;
    function IsPaintNodeEvent : Boolean; override;
    procedure Clear; virtual;
    property RootNode: TFDNode read FRootNode;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SendToScreen; virtual;
    function GetNbByLevel(MyLevel: Integer): Integer; virtual;
    function AddNode(MyNode: TFDNode): TFDNode; virtual;
    procedure DeleteActiveNode; virtual;
    procedure DoOnPaintNode ( const ANode : TFDNode ; const ACanvas : TCanvas ; const PaintRect : TRect ); override;
    procedure DeleteNode(MyNode: TFDNode); virtual;
    procedure DeleteItem(n: Integer); virtual;
    procedure SetDefaultActiveNode; virtual;
    property LabelInfo: TLabel Read FLabelInfo;
    property NodeList: TList Read FNodeList;
    property Node[Index: Integer]: TFDNode Read GetNode;
    property NodeCount: Integer Read GetNodeCount;
    property SelectedNode: TFDNode Read FSelectedNode;
    property AcceptRepaint: Boolean read FAcceptRepaint write SetAcceptRepaint;
  published
    property LineColor: TColor Read FLineColor Write SetLineColor Default clGray;
    property BackColor: TColor Read FBackColor Write SetBackColor Default ClBtnFace;
    property Margin: Integer Read FMargin Write SetIdent Default 4;
    property NodeType : TNodeType read FNodeType write FNodeType default ntPlain;
    property NodeMargin: Integer Read FNodeMargin Write SetNodeMargin Default 4;
    property TreeOrientation: TTreeOrientation  Read FTreeOrientation Write SetTreeOrientation Default toVertical;
    property NodeAlign: TNodeAlign Read FNodeAlign Write SetNodeAlign Default naNormal;
    property NodePopupMenu: TPopupMenu read FNodePopupMenu write SetNodePopupMenu;
    property NodeWidth: Integer Read FNodeWidth Write SetNodeWidth Default 50;
    property NodeHeight: Integer Read FNodeHeight Write SetNodeHeight Default 25;
    property NodeDefaultFont: TFont Read FNodeDefaultFont Write SetNodeDefaultFont;
    property OnPaintNode : EOnPaintNode read FOnPaintNode write FOnPaintNode;
    // Evénements du TreeView
    property OnSelectedNodeChange: TNodeNotifyEvent Read FSelectedNodeChange Write FSelectedNodeChange;
    // Evénement des noeuds
    property OnNodeClick: TNodeNotifyEvent Read FNodeClick Write FNodeClick;
    //property OnNodeDblClick: TNodeNotifyEvent Read FNodeDblClick Write FNodeDblClick;
    property OnNodeMouseDown: TNodeMouseEvent Read FNodeMouseDown Write FNodeMouseDown;
    // Publication des propriétés et événements Protected
    property Align;
    property PopupMenu;
    property ParentColor;
    property AutoEnlarge : Boolean read FAutoEnlarge write SetAutoEnlarge default False;
    // Evénements
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property TabStop;
  end;

  EFDTreeViewException = Class(Exception);

implementation

uses Themes, Math;
{********* TFDNode *********}
constructor TFDNode.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 50;
  FChildList := TList.Create;
  FAObject := Nil;
  AllowAllUp := True;
  GroupIndex := 1;
end;

// Effacement des enfants
// Erasing childs
procedure TFDNode.Clear;
var
  m: Integer;
begin
  // je detruis mes enfants de ma liste
  for m := 0 to FChildList.Count -1 do
    Begin
      TFDNode(FChildList.Items[m]).Free;
      FChildList.Delete ( m );
    End;
End;

// Destroying the component
// Destruction du composant
destructor TFDNode.Destroy;
var
  n: Integer;
begin
  //et enfin, je me détruis
  FAObject.Free;
  FAObject := Nil;
  if not FParentTree.FDestroyingRootnode Then
    Begin
      if FParentNode <> nil then
       for n := 0 to FParentNode.ChildList.Count -1 do
        // Je m'enlève de la liste des enfants de mon père
        if FParentNode.ChildList.Items[n] = Self then begin
          FParentNode.ChildList.Items[n] := Nil;
          FParentNode.ChildList.Pack;
          Break;
        end;

      for n := 0 to FParentTree.FNodeList.Count -1 do
      // Je m'enlève de la liste des noeuds du TreeView
        if FParentTree.FNodeList.Items[n] = Self then begin
          FParentTree.FNodeList.Items[n] := Nil;
          FParentTree.FNodeList.Pack;
          Break;
       end;
      Clear;
    End;
  FChildList.Free;
  inherited Destroy;
end;

procedure TFDNode.Paint;
var PaintRect : TRect ;
    SomeLastDrawDetails : TThemedElementDetails;
    Button: TThemedButton;
begin
  if FParentTree.IsPaintNodeEvent Then
    Begin
{$IFDEF FPC}
      PaintRect := ClientRect;
      SomeLastDrawDetails := GetDrawDetails;
      if not Transparent and ThemeServices.HasTransparentParts(SomeLastDrawDetails) then
      begin
        Canvas.Brush.Color := Color;
        Canvas.FillRect(PaintRect);
      end;
      ThemeServices.DrawElement(Canvas.Handle, SomeLastDrawDetails, PaintRect);
      PaintRect := ThemeServices.ContentRect(Canvas.Handle, SomeLastDrawDetails, PaintRect);
      PaintBackground(PaintRect);
{$ELSE}
    if not Enabled then
      Button := tbPushButtonDisabled
    else
      if FState in [bsDown, bsExclusive] then
        Button := tbPushButtonPressed
      else
        if MouseInControl then
          Button := tbPushButtonHot
        else
          Button := tbPushButtonNormal;

      SomeLastDrawDetails := ThemeServices.GetElementDetails(Button);
      PaintRect := ClientRect;
      Canvas.Brush.Color := Color;
      Canvas.FillRect(PaintRect);
      ThemeServices.DrawElement(Canvas.Handle, SomeLastDrawDetails, PaintRect);
      PaintRect := ThemeServices.ContentRect(Canvas.Handle, SomeLastDrawDetails, PaintRect);
{$ENDIF}
      FParentTree.DoOnPaintNode ( Self, Canvas, PaintRect );
    end
   else
    inherited Paint;
end;

function TFDNode.Getlevel: Integer;
var
  MyNode: TFDNode;
begin
  MyNode := Self;
  Result := 0;
  While MyNode <> Nil do begin
    Inc(Result);
    MyNode := MyNode.ParentNode;
  end;
end;

function TFDNode.AddChild(MyParentTree: TFDTreeView; AParentNode: TFDNode): TFDNode;
begin
  Result := TFDNode.Create(MyParentTree);
  With Result do begin
    ParentNode := AParentNode;
    ParentTree := MyParentTree;
    Level := ParentNode.Level + 1;
    AllowAllUp := True;
    if Level > 1 then GroupIndex := 1
                 else GroupIndex := 0;
    if ParentNode <> Nil then ParentNode.ChildList.Add(Result);
  end;
end;

procedure TFDNode.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FNodeGetFocus) then FNodeGetFocus(Self);
  inherited MouseDown(Button, Shift, X, Y);
end;

// Recurive function to set node
// Boucle récursive qui tri le noeud
procedure TFDNode.SendToScreen( const ALevel: Integer);
var
  n : Integer;
begin
  FLevel:=ALevel;
  Height := FParentTree.NodeHeight;
  Width  := FParentTree.NodeWidth;
  // Ordonnancement
  for n := 0 to FChildList.Count - 1 do
    TFDNode(FChildList.Items[n]).SendToScreen( FLevel + 1);
  Invalidate;
end;

// Draw parent link
// Dessine la liaison avec le parent
procedure TFDNode.DrawParentLink( );
begin
  if FParentNode <> Nil then
   With FParentTree.Canvas do
    begin
      Pen.Color := FParentTree.LineColor;
      if FParentTree.TreeOrientation = toVertical then
       begin
        if FParentTree.NodeAlign = naNormal Then
          MoveTo(FParentNode.Left + (FParentNode.Width div 2), FParentNode.Top + FParentNode.Height)
         Else// Inversion
          MoveTo(FParentNode.Left + (FParentNode.Width div 2), FParentNode.Top );
        if FParentTree.NodeAlign = naNormal Then
         if FParentTree.NodeType = ntPlain then
         begin
           LineTo(Self.Left + (Self.Width Div 2), Self.Top-5);
           rectangle (Self.Left + (Self.Width Div 2), Self.Top-5, Self.Left +1+ (Self.Width Div 2), Self.Top); // TRAIT VERTICAL
         end
        Else
          LineTo(Self.Left + (Self.Width Div 2), Self.Top)
        Else // Inversion
          LineTo(Self.Left + (Self.Width Div 2), Self.Top + Self.Height);
       end
      else
       begin
        if FParentTree.NodeAlign = naNormal Then
          MoveTo(FParentNode.Left + FParentNode.Width, FParentNode.Top + (FParentNode.Height div 2))
         Else  // Inversion
          MoveTo(FParentNode.Left, FParentNode.Top + (FParentNode.Height div 2));
        if FParentTree.NodeAlign = naNormal Then
         if FParentTree.NodeType = ntPlain then
         begin
           LineTo(Self.Left-5, Self.Top + (Self.Height Div 2));
           rectangle (Self.Left-5, Self.Top + (Self.Height Div 2), Self.Left, Self.Top + (Self.Height Div 2)); // TRAIT HORIZONTAL
         end
        Else
          LineTo(Self.Left, Self.Top + (Self.Height Div 2))
         Else  // Inversion
          LineTo(Self.Left+Self.Width, Self.Top + (Self.Height Div 2));
      end;
  end;
end;

{********* TFDTreeView *********}

// Creating the component
// Creation du composant
constructor TFDTreeView.Create(AOwner: TComponent);
begin
  FAcceptRepaint := false;
  inherited Create(AOwner);
  FNodeMargin := 4 ;
  FAutoEnlarge := False;
  FNodeType := ntPlain;
  FTotalMaxCount := 0;
  Parent := AOwner as TWinControl;
  FDestroyingRootNode := False;
  FNodeList := TList.Create;
  FLineColor := clGray;
  FBackColor := clBtnFace;
  FMargin := 4;
  FTreeOrientation := toVertical;
  FNodeHeight := 45;
  FNodeWidth := 70;
  FNodeAlign := naNormal;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  FNodeWidth := 50;
  FNodeHeight := 25;
  FNodeDefaultFont := TFont.Create;
  FRootNode := nil;

  // Painting at the end
  FAcceptRepaint := true;
end;

procedure TFDTreeView.Clear;
begin
  FDestroyingRootNode := True;
  try
    while FNodeList.count > 0  do
      Begin
        TObject(FNodeList.Items[0]).Free;
        FNodeList.Delete ( 0 );
      End;
  finally
    FDestroyingRootNode := False;
  end;
End;

Destructor TFDTreeView.Destroy;
begin
//  FLabelInfo.Free;
  Clear;
  FNodeList.Free;
  FNodeDefaultFont.Free;
  inherited Destroy;
end;

// Adding a node to the tree
// Ajout d'un noeaud dans l'arbre
function TFDTreeView.AddNode(MyNode: TFDNode): TFDNode;
begin
  Result := MyNode.AddChild(Self, MyNode);
  if MyNode = nil Then
    Begin
      if FRootNode <> nil
       Then
        Clear;
      FRootNode := Result;
    end;
  Result.Parent := Self;
  Result.OnNodeGetFocus := NodeGetFocus;
  if FNodeList <> Nil then With Result do begin
    Caption := IntToStr(Self.FNodeList.Count);
    Name := 'Noeud' + IntToStr(FNodeList.Count);
    PopupMenu := FNodePopupMenu;
    Width := FNodeWidth;
    Height := FNodeHeight;
    Font.Assign(FNodeDefaultFont);
    OnClick := NodeClickEvent;
    OnDblClick := NodeDblClickEvent;
    OnMouseDown := NodeMouseDownEvent;
  end;
  FNodeList.Add(Result);
  SendToScreen;
end;

procedure TFDTreeView.DeleteActiveNode;
begin
  if FNodeList.Count > 0 then begin
    FSelectedNode.Free;
    if FNodeList.Count > 0 then begin
      FSelectedNode := Node[0];
      NodeGetFocus(FSelectedNode);
    end;
  end;
  SendToScreen;
end;

procedure TFDTreeView.DoOnPaintNode(const ANode: TFDNode; const ACanvas : TCanvas  ; const PaintRect : TRect );
begin
  if assigned ( FOnPaintNode ) Then
    Begin
      FOnPaintNode ( Self, ANode, ACanvas, PaintRect );
    end;
end;
function TFDTreeView.IsPaintNodeEvent : Boolean;
begin
  Result := assigned ( FOnPaintNode ) ;
end;

procedure TFDTreeView.DeleteNode(MyNode: TFDNode);
begin
  FSelectedNode := MyNode;
  DeleteActiveNode;
end;

procedure TFDTreeView.DeleteItem(n: Integer);
begin
  if (n >= FNodeList.Count) or (n < 0) then
    raise EFDTreeViewException.Create('Index de liste hors limite (' + IntToStr(n) + ')');
  FSelectedNode := Node[n];
  DeleteActiveNode;
end;

function TFDTreeView.GetNode( Index: Integer): TFDNode;
begin
  Result := TFDNode(FNodeList.Items[Index]);
end;

procedure TFDTreeView.NodeGetFocus( Sender: TFDNode);
begin
  FSelectedNode := Sender;
  FSelectedNode.Down := True;
  if Assigned(FSelectedNodeChange) then FSelectedNodeChange(FSelectedNode);
end;

procedure TFDTreeView.SetDefaultActiveNode;
begin
  if FNodeList.Count > 0 then begin
    FSelectedNode := Node[0];
    NodeGetFocus(FSelectedNode);
  end;
end;

procedure TFDTreeView.SetLineColor(const Value: TColor);
begin
  if FLineColor <> Value then begin
    FLineColor := Value;
    Invalidate;
  end;
end;

procedure TFDTreeView.SetBackColor(const Value: TColor);
begin
  if FBackColor <> Value then begin
    FBackColor := Value;
    Color := FBackColor;
    Invalidate;
  end;
end;

procedure TFDTreeView.SetIdent(const Value: Integer);
begin
  if FMargin <> Value then begin
    FMargin := Value;
    SendToScreen;
  end;
end;

procedure TFDTreeView.SetTreeOrientation(const Value: TTreeOrientation);
begin
  if FTreeOrientation <> Value then begin
    FTreeOrientation  := Value;
    SendToScreen;
  end;
end;

procedure TFDTreeView.SetNodeAlign(const Value: TNodeAlign);
begin
  if FNodeAlign <> Value then begin
    FNodeAlign := Value;
    SendToScreen;
  end;
end;

procedure TFDTreeView.SetNodePopupMenu(const Value: TPopupMenu);
begin
  FNodePopupMenu := Value;
  if Value <> nil then begin
  {$IFNDEF FPC}
    Value.ParentBiDiModeChanged(Self);
  {$ENDIF}
    Value.FreeNotification(Self);
  end;
end;

procedure TFDTreeView.SetNodeWidth(const Value: Integer);
begin
  if FNodeWidth <> Value then
   begin
    FNodeWidth := Value;
    SendToScreen;
  end;
end;

procedure TFDTreeView.SetNodeMargin(const Value: Integer);
begin
  if FNodeMargin <> Value then
   begin
    FNodeMargin := Value;
    SendToScreen;
  end;
end;

procedure TFDTreeView.SetNodeHeight(const Value: Integer);
begin
  if FNodeHeight <> Value then begin
    FNodeHeight := Value;
    SendToScreen;
  end;
end;

procedure TFDTreeView.SetNodeDefaultFont(const Value: TFont);
begin
  FNodeDefaultFont.Assign(Value);
end;

function TFDTreeView.GetNodeCount: Integer;
begin
  Result := FNodeList.Count;
end;

procedure TFDTreeView.SetAcceptRepaint(const Value: Boolean);
begin
  if FAcceptRepaint <> Value Then
    Begin
      FAcceptRepaint:=Value;
      if FAcceptRepaint Then
        SendToScreen;
    end;
end;

procedure TFDTreeView.SetAutoEnlarge(const Value: Boolean);
begin
  FAutoEnlarge := Value;
  SendToScreen;
end;

function TFDTreeView.GetMaxLevel: Integer;
var
  n: Integer;
begin
  Result := 0;
  for n := 0 to FNodeList.Count -1 do
   with TFDNode(FNodeList.Items[n]) do
    if Level > Result then Result := Level;
end;

function TFDTreeView.GetNbByLevel(MyLevel: Integer): Integer;
var
  n: Integer;
begin
  Result := 0;
  for n := 0 to FNodeList.Count -1 do with TFDNode(FNodeList.Items[n]) do
    if Level = MyLevel then Inc(Result);
end;

// Setting the nodes which are unless at the same position
// Affectation des positions de noeuds qui sont sinon dans le désordre
procedure TFDTreeView.SendToScreen;
var ARootNode : TFDNode ;
begin
  if FAcceptRepaint then
   begin
    Enlarge;
    if FNodeList.Count > 0 then
     begin
       ARootNode := RootNode;
       if FTreeOrientation = toVertical
         then
           Begin
             ARootNode.Left := Width div 2 - ARootNode.Width div 2 ;
             if FNodeAlign = naInvert Then
                   ARootNode.Top  := Height - ARootNode.Height - Margin - BorderWidth
              else ARootNode.Top  := Margin + BorderWidth;
           end
         else
           Begin
             if FNodeAlign = naInvert Then
                   ARootNode.Left := Width - ARootNode.Width - Margin - BorderWidth
              Else ARootNode.Left := Margin + BorderWidth;
             ARootNode.Top  := Height div 2 - ARootNode.Height div 2 ;
           end;
        ARootNode.SendToScreen( 1 );
      end;
    SortNodes;
    Invalidate ;
  end;
end;
// Boucle récursive : Tri des adresses de noeuds
// Recurive function : Sorting NodeList Addresses
procedure TFDTreeView.SortAddrNodes ( const ANodeList : TList; const ANode : TFDNode );
var
  n : Integer;
begin
  ANodeList.Add(ANode);
  for n:= 0 to ANode.ChildList.Count - 1 do
    Begin
      SortAddrNodes ( ANodeList, TFDNode ( ANode.ChildList.Items [n]));
    End;

end;
// Tri des adresses de noeuds
// SOrting NodeList Addresses
procedure TFDTreeView.SortAddrNodes;
var
  SortList : TList ;
Begin
  if RootNode = Nil then
    Exit;
  SortList := TList.Create;
  SortAddrNodes ( SortList, RootNode );
  NodeList.Free;
  FNodeList := SortList;
End;
// Affectation des positions des noeauds dans le panel
// Setting positions of nodes in the panel
procedure TFDTreeView.SortNodes;
var
  AParentNode ,
  SomeNode : TFDNode ;
  CountChildNodes,
  Step,
//  StepParent,
  MaxChildNodes,
  APosition,
  SomeLevel,
  n , i,
  CountChildParentNodes,
  CountNoChildParentNodes ,
  AMaxLevel,
  SumNoChildParentNodes : LongInt;
  SortList : TList ;
  // Aligner les noeuds sur la ligne
  function GetAlignedNodesPos ( const NodeSize, ASize, ParentLeftTop : Longint ): Longint;
    Begin
{ Boucher les trous mais nécessite une tlist
  if (ASize/2)-(ParentLeftTop+NodeSize/2) <> 0 then
        Result := Trunc ( OldNoChildParentNodes * ((ASize/2)-(ParentLeftTop+NodeSize/2))/Abs((ASize/2)-(ParentLeftTop+NodeSize/2)) * StepParent / ( 2 * SortList.count ));
      if Result  > NodeSize * Margin div 2 then
        Begin
          Result  := NodeSize * Margin div 2 ;
        End;}
      Result := Round ( ParentLeftTop - (Step * ( CountChildParentNodes - 1 )) / 2
      + i * ( Step )) ;//,/CountChildNodes * Step + Step * (i / CountChildNodes + 1 / CountChildNodes * 0.5 ) - NodeSize / 2  + Margin )//+ OldNoChildParentNodes * Step div 2 + LeftTopPosition)        Result := Result + Trunc ( OldNoChildParentNodes * (ParentLeftTop-ASize/2)/Abs(ParentLeftTop-ASize/2) * Step );
    End;
  // Aligner les noeaud à chaque niveau
  function GetLeveledNodesPos ( const TreeSize, NodeSize : Longint ): Longint;
    Begin
      if NodeAlign = naInvert Then  // Inversion
        Result := TreeSize - NodeSize - ( NodeSize + FNodeMargin * 2 ) * ( SomeLevel - 1 ) - FMargin
       Else
        Result := ( NodeSize + FNodeMargin * 2 ) * ( SomeLevel - 1 ) + FMargin;
    End;
  // Ecart de noeaud
  function getStep ( const ASize : Longint ) : Longint;
  Begin
    Result := (ASize - Margin * 2) div ( SortList.Count + SumNoChildParentNodes );// + CountNoChildParentNodes ) *MaxChildNodes );//* MaxChildNodes + CountNoChildParentNodes );
    if result < 155 then result := 155; // valeur en dur il faudrait mettre la largeur du noeud en dynamique
  End;
  //
  // Position par rapport au noeaud parent
  procedure TestParentNode;
  Begin
    if  ( SomeNode.ParentNode <> AParentNode ) then
      Begin
        // Stockage du parent
        AParentNode := SomeNode.ParentNode;
        CountChildParentNodes := AParentNode.ChildList.Count;
        i := 0;
        inc ( APosition );
      End;
  End;
  procedure MaxChilds;
    Begin
      if CountChildParentNodes > MaxChildNodes then
        Begin
         MaxChildNodes:= CountChildParentNodes;
        End;

    End;
begin
  // Ordonnancement
  SortAddrNodes;
  SortList := Nil;
  AParentNode := nil;
  AMaxLevel := GetMaxLevel;
  SumNoChildParentNodes := 0;
  CountChildNodes := 0 ;
  try
    for SomeLevel := 2 to AMaxLevel do
      Begin
        // Recherche des noeuds en parallèle
        CountNoChildParentNodes := 0;//CountNoChildParentNodes div 2;
        CountChildParentNodes := 0;//CountNoChildParentNodes div 2;
        SortList := setSortList( SomeLevel, CountChildNodes, CountNoChildParentNodes );
        APosition := 0 ;
        i := 0;
        if TreeOrientation = toVertical then
          begin
            Step := getStep ( Width );
            //After getting step
            MaxChildNodes := 0 ;
            for n := 0 to SortList.Count -1 do
              Begin
                SomeNode := TFDNode(SortList.Items[n]);
                TestParentNode;
                MaxChilds;
                // Alignement par rapport au centre de la surface du treeview
                SomeNode.Left := GetAlignedNodesPos ( SomeNode.Width, Width - Margin * 2 , SomeNode.ParentNode.Left);
                // Décalage de NodeHeight vers le haut ou le bas
                SomeNode.Top := GetLeveledNodesPos ( Height - Margin * 2, SomeNode.Height );
                inc ( i );
              end;
           end
          else
           begin
            Step := getStep ( Height );
            //After getting step
            MaxChildNodes := 0 ;
            for n := 0 to SortList.Count -1 do
              Begin
                SomeNode := TFDNode(SortList.Items[n]);
                MaxChilds;
                TestParentNode;
                // Décalage de NodeWidth vers la gauche ou la droite
                SomeNode.Left := GetLeveledNodesPos ( Width - Margin * 2, SomeNode.Width );
                // Alignement par rapport au centre de la surface du treeview
                SomeNode.Top := GetAlignedNodesPos ( SomeNode.Height, Height - Margin * 2, SomeNode.ParentNode.Top );
                inc ( i );
              end;
           end;
       SumNoChildParentNodes := ( SumNoChildParentNodes + CountNoChildParentNodes ) * MaxChildNodes;
       SortList.Free;
       SortList := nil;

      end;
  finally
    SortList.Free;
  end;
  FTotalMaxCount := CountChildNodes + SumNoChildParentNodes;
  Invalidate;
end;
function TFDTreeView.setSortList ( const ALevel : Integer ; var CountedChildNodes, CountedNoChildParentNodes : Longint ):TList;
var n : integer;
    SomeNode : TFDNode;
Begin
  Result := TList.Create;
  for n := 0 to NodeList.Count - 1 do
    Begin
      SomeNode := TFDNode ( NodeList [ n ]);
      if  ( SomeNode.FLevel = ALevel )  then
        Begin
          if ( SomeNode.FChildList.Count = 0 ) then
            inc ( CountedNoChildParentNodes );
          Result.Add(SomeNode);
        End;
    End;
  CountedChildNodes := Result.Count;
End;

procedure TFDTreeView.setTotalMaxCount;
var
  SomeLevel,
  n ,
  OldCountNoChildParentNodes ,
  AMaxLevel,
  MaxChildNodes,
  CountChildNodes,
  CountNoChildParentNodes ,
  SumNoChildParentNodes : LongInt;
  SomeNode : TFDNode;
  SortList : TList ;
Begin
  OldCountNoChildParentNodes := 0 ;
  SumNoChildParentNodes      := 0 ;
  CountChildNodes            := 0 ;
  AMaxLevel                  := GetMaxLevel;
  for SomeLevel := 2 to AMaxLevel do
    Begin
      // Recherche des noeuds en parallèle
      CountNoChildParentNodes := 0;//CountNoChildParentNodes div 2;
      SortList := setSortList( SomeLevel, CountChildNodes, CountNoChildParentNodes );
            //After getting step
      MaxChildNodes := 0 ;
      for n := 0 to SortList.Count -1 do
        Begin
          SomeNode := TFDNode(SortList.Items[n]);
          if SomeNode.ParentNode.ChildList.Count > MaxChildNodes then
            Begin
             MaxChildNodes:= SomeNode.ParentNode.ChildList.Count;
            End;
        end;
       SumNoChildParentNodes := ( SumNoChildParentNodes + OldCountNoChildParentNodes ) * MaxChildNodes;
       OldCountNoChildParentNodes := CountNoChildParentNodes;
       SortList.Free;
    End;
  FTotalMaxCount := CountChildNodes + SumNoChildParentNodes;
end;

// Méthodes surchargées
procedure TFDTreeView.Paint;
var
  m: Integer;
begin
  inherited;
  for m := 0 to FNodeList.Count -1 do
    Begin
      Node[m].DrawParentLink();
    end;
end;

procedure TFDTreeView.Enlarge;
var MaxLevel  ,
    MaxWidth  ,
    MaxHeight : LongInt;
  function getMaxLeveledSize ( const NodeSize : integer ): Longint;
    Begin
      Result := MaxLevel * ( NodeSize + FNodeMargin * 2 ) + Margin * 2;
    End;
  function getMaxNodesCountLeveledSize ( const NodeSize : integer ): Longint;
    Begin
      Result := ( NodeSize + FNodeMargin * 2 ) * FTotalMaxCount + Margin * 2;
    End;
begin
  if not FAutoEnlarge then
    Exit;
  MaxLevel := GetMaxLevel;
  setTotalMaxCount;
  if TreeOrientation = toVertical then
    Begin
      MaxHeight := getMaxLeveledSize ( NodeHeight );
      MaxWidth  := getMaxNodesCountLeveledSize ( NodeWidth );
    End
   Else
    Begin
      MaxHeight := getMaxNodesCountLeveledSize ( NodeHeight );
      MaxWidth  := getMaxLeveledSize ( NodeWidth );
    End;
   if  ( MaxWidth  > Width ) Then
     Begin
       if Align = alClient then
         Align := alLeft ;
       if Align in [alBottom,alTop] then
         Align := alNone ;
       Width := MaxWidth;
     End;
   if ( MaxHeight > Height ) Then
     Begin
       if Align = alClient then
         Align := alTop ;
       if Align in [alLeft,alRight] then
         Align := alNone ;
       Height := MaxHeight;
     End;
end;
procedure TFDTreeView.Resize;
begin
   if not FAutoEnlarge Then
    Begin
      inherited;
      SendToScreen;
    end;
end;

{******* Evénément des noeuds ******* }
procedure TFDTreeView.NodeClickEvent( Sender: TObject);
begin
  if Assigned(FNodeClick) then FNodeClick(Sender as TFDnode);
end;

procedure TFDTreeView.NodeDblClickEvent(Sender: TObject);
begin
  if Assigned(FNodeDblClick) then FNodeDblClick(Sender as TFDnode);
end;

procedure TFDTreeView.NodeMouseDownEvent( Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FNodeMouseDown) then FNodeMouseDown(Sender as TFDNode, Button, Shift, X, Y);
end;


end.


