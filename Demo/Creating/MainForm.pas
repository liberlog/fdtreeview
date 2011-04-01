unit MainForm;

{$IFDEF FPC}
{$MODE Delphi}
{$R *.lfm}
{$ELSE}
{$R *.DFM}
{$ENDIF}

interface

uses
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ImgList, ComCtrls, StdCtrls, ExtCtrls, Buttons, ToolWin,
{$IFDEF FPC}
  LCLIntf, LCLType,
{$ELSE}
  rxPlacemnt, Windows,
{$ENDIF}
  FDTreeView;

const
  DefaultFileName = 'Defaut.soc';

type
  TDlgMainForm = class(TForm)
    MainMenu1: TMainMenu;
    ImageListMainMenu: TImageList;
    MnFichier: TMenuItem;
    MnQuitter: TMenuItem;
    ToolBar1: TToolBar;
    PupMenuNode: TPopupMenu;
    PupMenuTree: TPopupMenu;
    MnSensAffichage: TMenuItem;
    ColorDialog1: TColorDialog;
    Couleur1: TMenuItem;
    MnAjouterUnNoeud: TMenuItem;
    MnEditerLeNoeud: TMenuItem;
    ImageListPupMenuNode: TImageList;
    MnSupprimerLeNoeud: TMenuItem;
    N2: TMenuItem;
    Alignementdesnoeuds1: TMenuItem;
    MnLibre: TMenuItem;
    AligneSousLePere: TMenuItem;
    N4: TMenuItem;
    MnNouvelArbre: TMenuItem;
    MnSensAffVertical: TMenuItem;
    MnSensAffHorizontal: TMenuItem;
{$IFNDEF FPC}
    MainFormStorage: TFormStorage;
{$ENDIF}
    N1: TMenuItem;
    ImageListPupMenuTree: TImageList;
    ToolBtnNouvelArbre: TToolButton;
    ToolBtnOuvrir: TToolButton;
    N5: TMenuItem;
    MnOuvrirUnFichier: TMenuItem;
    OpenDlgTree: TOpenDialog;
    MnEnregistrer: TMenuItem;
    MnEnregistrerSous: TMenuItem;
    N6: TMenuItem;
    ToolBtnEnregistrer: TToolButton;
    TollBtnEnregistrerSous: TToolButton;
    SaveDlgTree: TSaveDialog;
    ToolButton1: TToolButton;
    MainStatusBar: TStatusBar;
    MnPrefrences: TMenuItem;
    N3: TMenuItem;
    MnAPropos: TMenuItem;
    MnInformations: TMenuItem;
    N9: TMenuItem;
    Panel2: TPanel;
    Label1: TLabel;
    MTV: TFDTreeView;
    procedure MnQuitterClick(Sender: TObject);
    procedure Couleur1Click(Sender: TObject);
    procedure MnAjouterUnNoeudClick(Sender: TObject);
    procedure MnEditerLeNoeudClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure MnLibreClick(Sender: TObject);
    procedure AligneSousLePereClick(Sender: TObject);
    procedure MnSupprimerLeNoeudClick(Sender: TObject);
    procedure MnNouvelArbreClick(Sender: TObject);
    procedure MnSensAffVerticalClick(Sender: TObject);
    procedure MnSensAffHorizontalClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MTVSelectedNodeChange(Sender: TFDNode);
    procedure MnOuvrirUnFichierClick(Sender: TObject);
    procedure MnEnregistrerClick(Sender: TObject);
    procedure MnEnregistrerSousClick(Sender: TObject);
    procedure MnPrefrencesClick(Sender: TObject);
{$IFNDEF FPC}
    procedure MainFormStorageSavePlacement(Sender: TObject);
    procedure MainFormStorageRestorePlacement(Sender: TObject);
{$ENDIF}
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PupMenuNodePopup(Sender: TObject);
    procedure MnAProposClick(Sender: TObject);
    procedure MTVNodeClick(Sender: TFDNode);
    procedure MnInformationsClick(Sender: TObject);
  private
    g_ExecDir: String;
    FSelectedNode: TFDNode;
    FCurrentFileName: String;
    FTreeChanged: Boolean;
    procedure FirstInit;
    procedure Preferences;
{$IFNDEF FPC}
    procedure SaveIniFile;
    procedure LoadIniFile;
{$ENDIF}
    procedure SetComponents;
    procedure VoirAPropos;
    procedure SupprimeArbre(MyTree: TFDTreeView);
    procedure NouvelArbre(MyTree: TFDTreeView);
    procedure EditerLeNoeud;
    procedure AjouterUnNoeud;
    procedure SaveTreeToFile(MyTree: TFDTreeView; FileName: String);
    procedure LoadTreeFromFile(MyTree: TFDTreeView; FileName: String);
    procedure OuvrirUnFichier;
    procedure EnregistrerSous;
    procedure Enregistrer;
    procedure AfficherNodeInfo(aNode: TFDNode);
  public
    { Déclarations publiques }
  end;

var
  DlgMainForm: TDlgMainForm;

implementation
uses
  IniFiles, About, Miscel, SetNodeProperties, Preferences;

Const
  RC = #13#10;

var
  bFirstInit: Boolean;
procedure TDlgMainForm.FirstInit;
begin
  if not bFirstInit then begin
    FSelectedNode := Nil;
    if FileExists(FCurrentFileName) then LoadTreeFromFile(MTV, FCurrentFileName)
                                    else begin
      FCurrentFileName := DefaultFileName;
      NouvelArbre(MTV);
    end;
    SetComponents;
    bFirstInit := true;
  end;
end;
{$IFNDEF FPC}
procedure TDlgMainForm.SaveIniFile;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(MainFormStorage.IniFileName);
  With IniFile do try
    WriteString('Application', 'LastTree', FCurrentFileName);
  finally
    IniFile.Free;
  end;
end;

procedure TDlgMainForm.LoadIniFile;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(MainFormStorage.IniFileName);
  With IniFile do try
    FCurrentFileName := ReadString('Application', 'LastTree', g_ExecDir + 'Defaut.soc');
  finally
    IniFile.Free;
  end;
end;
{$ENDIF}

procedure TDlgMainForm.SetComponents;
var
  b: Boolean;
begin
  MnLibre.Checked := (Mtv.NodeAlign = naNormal);
  AligneSousLePere.Checked := (Mtv.NodeAlign = naInvert);
  MnSensAffVertical.Checked := (MTV.TreeOrientation = toVertical);
  MnSensAffHorizontal.Checked := (MTV.TreeOrientation = toHorizontal);
  b := (FSelectedNode <> Nil) and (FSelectedNode.Level > 1);
  MnEditerLeNoeud.Enabled := b;
  MnInformations.Enabled := b;
end;

procedure TDlgMainForm.VoirAPropos;
var
  Dlg: TDlgAbout;
begin
  Dlg := TDlgAbout.Create(Self);
  With Dlg do try
    ShowModal;
  finally
    free;
  end;
end;

procedure TDlgMainForm.SupprimeArbre(MyTree: TFDTreeView);
begin
  if MyTree.NodeCount > 1 then
    if BoiteMessage('Effacer l''arbre en cours ?', 'Nouvel arbre', {Mb_IconQuestion +} Mb_YesNo) <> IdYes then Abort;
  { Pour supprimer un arbre il suffit de supprimer le noeud 0 (S'il existe) Car
    un noeud supprime ses enfants automatiquement. La suppression du noeud 0 entraine donc
    la suppression de tous les autres noeuds de l'arbre }
  if MyTree.NodeCount > 0 then MyTree.DeleteItem(0);
end;

procedure TDlgMainForm.NouvelArbre(MyTree: TFDTreeView);
var
  MyNode: TFDNode;
begin
  { Pour "Nouvel arbre" on supprime l'arbre existant (Voir remarque de la méthode "SupprimeArbre")
  Puis on ajoute un premier noeud (Pas obligatoire mais cela donne un point de départ
  à l'utilisateur }
  If MyTree.NodeCount > 0 then MyTree.DeleteItem(0);
  MyNode := MyTree.AddNode(Nil);
  MyNode.Caption := '1er Noeud';
  FCurrentFileName := DefaultFileName;
  SetComponents;
  FTreeChanged := False;
  SetComponents;
end;

procedure TDlgMainForm.EditerLeNoeud;
var
  Dlg: TDlgSetNodeProperties;
begin
  Dlg := TDlgSetNodeProperties.Create(Self);
  With Dlg do Try
    Caption := 'Editer un noeud';
    { On récupère le noeud courant et on l'edite}
    Node := MTV.SelectedNode;
{$IFDEF FPC}
    ShowModal;
    if FOkClick{$ELSE}
    if Showmodal {$ENDIF} = MrOk
     Then
      Begin
        { Et on lui affecte les nouvelles propriétés }
        SetNodeProperties(MTV.SelectedNode);
      end;
  finally
    Release;
  end;
  FTreeChanged := True;
  SetComponents;
end;

procedure TDlgMainForm.AjouterUnNoeud;
var
  MyNode: TFDNode;
  Dlg: TDlgSetNodeProperties;
begin
  Dlg := TDlgSetNodeProperties.Create(Self);
  With Dlg do Try
    Caption := 'Ajouter un noeud';
{$IFDEF FPC}
    ShowModal;
    if FOkClick{$ELSE}
    if Showmodal {$ENDIF} = MrOk
    then begin
      { On a besoin de MyNode pour affecter les propriétés du noeud
        Mais dand l'absolue "MTV.AddNode(MTV.SelectedNode);" suffit à ajouter
        un noeud }
      MyNode := MTV.AddNode(MTV.SelectedNode);
      SetNodeProperties(MyNode);
    end;
  finally
    Release;
  end;
  FTreeChanged := True;
  SetComponents;
end;

{ Pour l'instant, les noeud ne savent pas se sauvegarder sur disque (C'est une lacune)
  donc la sauvegarde d'un arbre passe par la sauvegarde "manuelle" de tous les noeuds
  Cela oblige à coder la sauvegarde de  toutes les propriétés d'un noeud
  Dans cette exemple seule la caption est sauvegardée. Ce qui explique que la "Font" soit
  perdue lors du chargement d'un arbre.
  Si un Delphinaute code une sauvagarde complètre, je suis preneur }
procedure TDlgMainForm.SaveTreeToFile(MyTree: TFDTreeView; FileName: String);
var
  n: Integer;
  IniFile: TIniFile;
  OldCursor: TCursor;
begin
  DeleteFile({$IFNDEF FPC}@{$ENDIF}FileName);
  IniFile := TIniFile.Create(FileName);
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    With MyTree, NodeList, IniFile do for n := 0 to NodeCount -1 do begin
      WriteInteger('Node' + IntToStr(n), 'ParentNode', NodeList.IndexOf(TFDNode(Items[n]).ParentNode));
      WriteString('Node' + IntToStr(n), 'Caption', TFDNode(Items[n]).Caption);
    end;
    FTreeChanged := False;
    SetComponents;
  finally
    Screen.Cursor := OldCursor;
    IniFile.Free;
  end;
end;

{ Voir remarque sur SaveTreeToFile }
procedure TDlgMainForm.LoadTreeFromFile(MyTree: TFDTreeView; FileName: String);
var
  n: Integer;
  IniFile: TIniFile;
  MyNode: TFDNode;
  SectionList: TStringList;
  MyParentNode: Integer;
begin
  SupprimeArbre(MyTree);
  SectionList := TStringList.Create;
  IniFile := TIniFile.Create(FileName);
  try
    With MyTree, IniFile do begin
      ReadSections(SectionList);
      for n := 0 to SectionList.Count -1 do begin
        MyParentNode := ReadInteger(SectionList.Strings[n], 'ParentNode', -1);
        if MyParentNode = -1 then begin
          MyNode := AddNode(Nil);
          MyNode.Caption := '1er Noeud';
        end else begin
          MyNode := AddNode(MyTree.Node[MyParentNode]);
          MyNode.Caption := ReadString('Node' + IntToStr(n), 'Caption', 'rien');
        end;
      end;
    end;
  finally
    IniFile.Free;
    SectionList.Free;
  end;
end;

procedure TDlgMainForm.OuvrirUnFichier;
begin
  With OpenDlgTree do begin
    InitialDir := g_ExecDir;
    if Execute then begin
      FCurrentFileName := FileName;
      LoadTreeFromFile(MTV, FCurrentFileName);
      FTreeChanged := False;
      SetComponents;
    end;
  end;
end;

procedure TDlgMainForm.EnregistrerSous;
begin
  With SaveDlgTree do begin
    if LowerCase(ExtractFileName(FCurrentFileName)) = LowerCase(DefaultFileName) then InitialDir := g_ExecDir
                                                                                 else InitialDir := ExtractFilePath(FCurrentFileName);
    Filename := ExtractFilename(FCurrentFileName);
    if Execute then begin
      FCurrentFileName := FileName;
      SaveTreeToFile(MTV, FCurrentFileName);
      SetComponents;
    end;
  end;
end;

procedure TDlgMainForm.Enregistrer;
begin
  if LowerCase(ExtractFileName(FCurrentFileName)) = LowerCase(DefaultFileName) then EnregistrerSous
                                                                               else SaveTreeToFile(MTV, FCurrentFileName);
end;

{********** Appel des dialogues de configuration *********}
procedure TDlgMainForm.Preferences;
var
  Dlg: TDlgPreferences;
begin
  Dlg := TDlgPreferences.Create(Self);
  With Dlg do try
    TreeButtonHeight := MTV.NodeHeight;
    TreeButtonWidth := MTV.NodeWidth;
    TreeMargin := MTV.Margin;
    AffichageV := (MTV.TreeOrientation = toVertical);
    if ShowModal = MrOk then begin
      MTV.AcceptRepaint := False;
      MTV.NodeHeight := TreeButtonHeight;
      MTV.NodeWidth := TreeButtonWidth;
      MTV.Margin := TreeMargin;
      MTV.AcceptRepaint := True;
    end;
  finally
    Free;
  end;
end;

procedure TDlgMainForm.AfficherNodeInfo(aNode: TFDNode);
begin
  if FSelectedNode.Level > 1 then begin
    ShowMessage('Information sur le noeud    "' + aNode.Caption + '"' + RC +
                'On peut récupérer ici toutes les propriétés du noeud' + RC +
                'Dans le cas présent il n''y a que la caption qui est récupérée'); 
  end else BoiteMessage('Faites un clique droit sur "1er Noeud" pour ajouter un noeud',
                        'Ajouter un noeud', mb_IconExclamation + mb_Ok);
end;

{**********************************************************}
{*                         Interface                      *}
{**********************************************************}
procedure TDlgMainForm.FormActivate(Sender: TObject);
begin
  FirstInit;
end;

procedure TDlgMainForm.FormCreate(Sender: TObject);
begin
  g_ExecDir := ExtractFilePath(Application.ExeName);
{$IFNDEF FPC}
  MainFormStorage.IniFileName := g_ExecDir + 'DemoFDTreeView.ini';
{$ENDIF}
end;

procedure TDlgMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FTreeChanged then
    if BoiteMessage('Souhaitez vous enregistrer les changements dans l''arbre des filtres ?',
                    'Enregistrer les changements.', Mb_IconQuestion + Mb_YesNo) = IdYes then Enregistrer;
  CanClose := True;
end;

procedure TDlgMainForm.MnQuitterClick(Sender: TObject);
begin
  Application.Terminate
end;

procedure TDlgMainForm.MnAjouterUnNoeudClick(Sender: TObject);
begin
  AjouterUnNoeud;
end;

procedure TDlgMainForm.MnEditerLeNoeudClick(Sender: TObject);
begin
  EditerLeNoeud;
end;

procedure TDlgMainForm.MnSupprimerLeNoeudClick(Sender: TObject);
begin
  if BoiteMessage('Etes vous sur de vouloir supprimer ce noeud' + RC
                + 'ainsi que la branche attachée?', 'Supprimer un noeud',
                mb_IconQuestion + mb_YesNo) = idYes then MTV.DeleteActiveNode;
end;

procedure TDlgMainForm.MnNouvelArbreClick(Sender: TObject);
begin
  SupprimeArbre(MTV);
  NouvelArbre(MTV);
end;

procedure TDlgMainForm.MnLibreClick(Sender: TObject);
begin
  Mtv.NodeAlign := naNormal;
  SetComponents;
end;

procedure TDlgMainForm.AligneSousLePereClick(Sender: TObject);
begin
  Mtv.NodeAlign := naInvert;
  SetComponents;
end;

procedure TDlgMainForm.MnSensAffVerticalClick(Sender: TObject);
begin
  MTV.TreeOrientation := toVertical;
  SetComponents;
end;

procedure TDlgMainForm.MnSensAffHorizontalClick(Sender: TObject);
begin
  MTV.TreeOrientation := toHorizontal;
  SetComponents;
end;

procedure TDlgMainForm.Couleur1Click(Sender: TObject);
begin
  if ColorDialog1.Execute then begin
    MTV.BackColor := ColorDialog1.Color;
  end;
end;

procedure TDlgMainForm.MTVSelectedNodeChange(Sender: TFDNode);
begin
  FSelectedNode := Sender;
  SetComponents;
end;

procedure TDlgMainForm.MnOuvrirUnFichierClick(Sender: TObject);
begin
  OuvrirUnFichier;
end;

procedure TDlgMainForm.MnEnregistrerClick(Sender: TObject);
begin
  Enregistrer;
end;

procedure TDlgMainForm.MnEnregistrerSousClick(Sender: TObject);
begin
  EnregistrerSous;
end;

procedure TDlgMainForm.MnPrefrencesClick(Sender: TObject);
begin
  Preferences;
end;

{$IFNDEF FPC}
procedure TDlgMainForm.MainFormStorageSavePlacement(Sender: TObject);
begin
  SaveIniFile;
end;

procedure TDlgMainForm.MainFormStorageRestorePlacement(Sender: TObject);
begin
  LoadIniFile;
end;
{$ENDIF}

procedure TDlgMainForm.PupMenuNodePopup(Sender: TObject);
begin
  MnSupprimerLeNoeud.Enabled := (FSelectedNode.ParentNode <> Nil);
end;

procedure TDlgMainForm.MnAProposClick(Sender: TObject);
begin
  VoirAPropos;
end;

procedure TDlgMainForm.MTVNodeClick(Sender: TFDNode);
begin
  AfficherNodeInfo(Sender);
end;

procedure TDlgMainForm.MnInformationsClick(Sender: TObject);
begin
  AfficherNodeInfo(MTV.SelectedNode);
end;

end.