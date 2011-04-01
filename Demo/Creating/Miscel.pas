unit Miscel;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface
uses
  Sysutils,
{$IFDEF FPC}
  LCLIntf, LCLType,
{$ELSE}
  Windows,
{$ENDIF}
  Classes, Forms, Controls, Graphics ;

function ExtractBetween(chaine, chaine1, chaine2: string):string;
function CompactDate(MyDate: TdateTime): String;
function CompactDateTime(ADate: TDateTime): String;
function DecompactDateTime(ADate: String): TDateTime;
function DecompactDateTimeString(ADate: String ): String;
function DecompactDateTimeFileName(FileName: String): String;
function ExtractFileNameBeforeExtension(FileName: String): String;
function DateToStrForFile(MyDate: TDateTime): String;
function TimeToStrForFile(MyTime: TDateTime): String;
function SetFileNameUnixToDos(FileName: String): String;
function FindAndReplace(Chaine, FromValue, ToValue: String): String;
function FindAndReplaceAll(Chaine, FromValue, ToValue: String): String;
function BoiteMessage(Texte, Titre: String; Option: Integer): Integer;
function SupprimeAccent(Texte: String): String;
function ExtendedTrim(s: string): string;
function GetDateFromString(s: String): String;
procedure GetKeyWordList(Chaine, KeyWord: String; Liste: TStrings);
function SupprimeCaractereNonAffichable(Texte: String): String;
function SupprimeRetourChariot(Texte: String): String;
function GetFirstWord(Chaine, Sep: String): String;
function GetKeyWord(Chaine, KeyWord, Sep: String): String;
function CodeString(Chaine, Code: String): String;
function DecodeString(Chaine, Code: String): String;
procedure PositionneToutControle(MyForm: TForm; Value: Boolean);
function GetaWordFromKey(Chaine, KeyWord, Sep: String): String;
function GetaWordFromIndex(Chaine: String; Index: Integer; Sep: String): String;
function NormalizeRequetePourDB(Requete: String): String;
function NormalizeRequetePourIB(Requete: String): String;
function PosFrom(Substr, Str: String; Index: Integer): Integer;
procedure Temporisation(t: Integer);
function NormalizeDecimalSeparator(Value: String): String;
function FormatMonnaieChaine(Value: String; Decimal: Byte): String;

{Contrôle/Creation de répertoire  Gestion de fichiers}
type
  TCreateDir = (cdirNo, cdirYes, cdirConfirm, cdirConfirmEach);
procedure CheckDirectory(dir: string; CreateDir: TCreateDir);
procedure LireDir(FileName: String; Attr: Integer; ListDir: TStrings);
function NormalizeDirectoryName(Name : String): string;
function NormalizeFileName(Name : String): string;
procedure FDCopyFiles(FileName, DestDir: String; FailIfExist: Boolean);
procedure FDDeleteFiles(FileName: String);
procedure FDFileSetAttr(FileName: String; Attr: Integer);
procedure FDRenameFiles(FileName, FileDest: String);
procedure DemanderConfirmationSiFichierExiste(FileName: String);
procedure GetFile(DirName, FileMask: String; Attr: Integer; ListDir: TStrings);

{Gestion du curseur de la souris}
procedure PushC(MCursor : TCursor);
procedure PopC;

{Gestion de Canvas }
procedure DrawCheckBox(Canvas: TCanvas; Rect: TRect);

{Math}
function Arrondie(Value: Double; Decimal: Byte): Double;




implementation
uses
  Dialogs, Buttons, ComCtrls, StdCtrls, Menus, DBGrids, {shdocvw,} DBCtrls,
  fonctions_file;

const
  rc = #13#10;
var
  PushCursor : array[0..511] of TCursor;
  MSIndex : Integer;

function extractbetween(chaine,chaine1,chaine2: string):string;
var
s:string;
begin
  s:='';
  if (chaine1 = '*') and (chaine2 = '*') then Result := chaine
                                         else if (chaine1='*') then begin
    s := chaine;
    if pos(chaine2,s) > 0 then Result := copy(s,1,pos(chaine2,s)-1)
                          else Result := s;
  end else if (chaine2 = '*') then begin
    if pos(chaine1,chaine)>0 then s := trim(copy(chaine,pos(chaine1,chaine)+length(chaine1),length(chaine)))
                             else s := chaine;
    Result := s;
  end else begin
    s := copy(chaine,pos(chaine1,chaine)+length(chaine1),length(chaine));
    Result:=copy(s,1,pos(chaine2,s)-1);
  end;
end;

function CompactDate(MyDate: TdateTime): String;
var
  Year, Month, Day: Word;
  sYear, sMonth, sDay: String;
begin  
  DecodeDate(MyDate, Year, Month, Day);
  sYear := IntToStr(Year); if Length(sYear) = 2 then sYear := '20' + sYear;
  sMonth := IntToStr(Month);  
  While Length(SMonth) < 2 do sMonth := '0' + sMonth;
  sDay := IntToStr(Day);
  While Length(SDay) < 2 do sDay := '0' + SDay;
  Result := sYear + sMonth + sDay;
end;

function DecompactDateTime(ADate: String ): TDateTime;
var
  StAA,StMM,StJJ,
  StHH,StMN,StSS: String;
begin
  Result := Now;
  if (ADate <> '') and (Copy(ADate,1,1) <> '0') then begin
    StAA := Copy(ADate,1,4);
    StMM := Copy(ADate,5,2);
    StJJ := Copy(ADate,7,2);
    StHH := Copy(ADate,9,2);
    StMN := Copy(ADate,11,2);
    StSS := Copy(ADate,13,2);
    ADate := StJJ+'/' + StMM + '/' + StAA  + ' ' +StHH  + ':' + StMN  + ':' + StSS;
    try
      Result := StrToDateTime(ADate);
    except
      // La fonction n'echoue jamais
    end;
  end;
end;

function DecompactDateTimeString(ADate: String ): String;
var
  StAA,StMM,StJJ,
  StHH,StMN,StSS: String;
begin
  Result := '';
  if (ADate <> '') and (Copy(ADate,1,1) <> '0') then begin
    StAA := Copy(ADate,1,4);
    StMM := Copy(ADate,5,2);
    StJJ := Copy(ADate,7,2);
    StHH := Copy(ADate,9,2);
    StMN := Copy(ADate,11,2);
    StSS := Copy(ADate,13,2);
    ADate := StJJ+'/' + StMM + '/' + StAA  + ' ' +StHH  + ':' + StMN  + ':' + StSS;
    Result := ADate;
  end;
end;

function CompactDateTime( ADate: TDateTime ):String;
Var
  AA,MM,JJ,
  HH,MN,SS,DS:Word;
  StAA,StMM,StJJ,
  StHH,StMN,StSS:String;
begin
  Result := '';
  DecodeDate(ADate,AA,MM,JJ);
  DecodeTime(ADate,HH,MN,SS,DS);
  StAA := IntToStr(AA); While Length(StAA)<2 do StAA := '0' + StAA;
  StMM := IntToStr(MM); While Length(StMM)<2 do StMM := '0' + StMM;
  StJJ := IntToStr(JJ); While Length(StJJ)<2 do StJJ := '0' + StJJ;
  StHH := IntToStr(HH); While Length(StHH)<2 do StHH := '0' + StHH;
  StMN := IntToStr(MN); While Length(StMN)<2 do StMN := '0' + StMN;
  StSS := IntToStr(SS); While Length(StSS)<2 do StSS := '0' + StSS;
  Result := StAA + StMM + StJJ + StHH + StMN + StSS;
end;

function ExtractFileNameBeforeExtension(FileName: String): String;
begin
  Result := ExtractFileName(FileName);
  if Pos('.', Result) <> 0 then Result := Copy(Result, 1, Pos('.', Result) -1)
end;

function DateToStrForFile(MyDate: TDateTime): String;
var
  Year, Month, Day: Word;
  SYear, SMonth, SDay: String;
begin
  DecodeDate(MyDate, Year, Month, Day);
  SDay := IntToStr(Day);
  While Length(SDay) < 2 do SDay := '0' + SDay;
  SMonth := IntToStr(Month);
  While Length(SMonth) < 2 do SMonth := '0' + SMonth;
  SYear := IntToStr(Year);
  Result := SDay + '-' + SMonth + '-' + SYear;
end;

function TimeToStrForFile(MyTime: TDateTime): String;
var
  Hour, Min, Sec, MSec: Word;
  SHour, SMin, SSec : String;
begin
  DecodeTime(MyTime, Hour, Min, Sec, MSec);
  SHour := IntToStr(Hour);
  While Length(SHour) < 2 do SHour := '0' + SHour;
  SMin := IntToStr(Min);
  While Length(SMin) < 2 do SMin := '0' + SMin;
  SSec := IntToStr(Sec);
  While Length(SSec) < 2 do SSec := '0' + SSec;
  Result := SHour + 'h' + SMin + 'mn' + SSec + 's';
end;

function DecompactDateTimeFileName(FileName: String): String;
var
  s, s1: String;
begin
  s := ExtractFileName(FileName);
  s1 := ExtractFileName(FileName);
  s := Copy(s, Pos('.', s) -14, 14);
  s := DecompactDateTimeString(s);
  s1 := Copy(s1, 1, Pos('.', s1) -15);
  Result := s1 + ' ' + s;
end;

function FindAndReplace(Chaine, FromValue, ToValue: String): String;
var
  P: Integer;
begin
  P := Pos(FromValue, Chaine);
  if P <> 0 then begin
     Delete(Chaine, P, Length(FromValue));
     Insert(ToValue, Chaine, P);
  end;
  Result := Chaine;
end;

function FindAndReplaceAll(Chaine, FromValue, ToValue: String): String;
begin
  Result := Chaine;
  While Pos(FromValue, Result) <> 0 do Result := FindAndReplace(Result, FromValue, ToValue);
end;

function SetFileNameUnixToDos(FileName: String): String;
begin
  Result := FindAndReplaceAll(FileName, '/', '\');
  Result := FindAndReplaceAll(Result, '\\', '\');
end;

function BoiteMessage(Texte, Titre: String; Option: Integer): Integer;
begin
  Result := Application.MessageBox(PChar(Texte), PChar(Titre), Option);
end;

// Trim + Supression de ',' '.' ';'  '-'
function ExtendedTrim(s: string): string;
const
  BadChar = ' .,;:?!-';
begin
  Result := Trim(s);
  While (Result <> '') and (Pos(Result[1], BadChar) <> 0) do Delete(Result, 1, 1);
  While (Result <> '') and (Pos(Result[Length(Result)], BadChar) <> 0) do Delete(Result, Length(Result), 1);
end;

function SupprimeAccent(Texte: String): String;
begin
  Result := Texte;
  Result := FindAndreplaceAll(Result, 'à', 'a');
  Result := FindAndreplaceAll(Result, 'â', 'a');
  Result := FindAndreplaceAll(Result, 'ä', 'a');

  Result := FindAndreplaceAll(Result, 'é', 'e');
  Result := FindAndreplaceAll(Result, 'è', 'e');
  Result := FindAndreplaceAll(Result, 'ê', 'e');
  Result := FindAndreplaceAll(Result, 'ë', 'e');

  Result := FindAndreplaceAll(Result, 'î', 'i');
  Result := FindAndreplaceAll(Result, 'ï', 'i');

  Result := FindAndreplaceAll(Result, 'ô', 'o');
  Result := FindAndreplaceAll(Result, 'ö', 'o');

  Result := FindAndreplaceAll(Result, 'ù', 'u');
  Result := FindAndreplaceAll(Result, 'û', 'u');
  Result := FindAndreplaceAll(Result, 'ü', 'u');

  Result := FindAndreplaceAll(Result, 'ç', 'c');
end;

function GetFirstWord(Chaine, Sep: String): String;
begin
  Result := Chaine;
  if Pos(Sep, Chaine) <> 0 then Result := Copy(Result, 1, Pos(Sep, Chaine) -1);
end;

// Cherche un mot clef dans une chaine  (KEYWORD=)
function GetKeyWord(Chaine, KeyWord, Sep: String): String;
begin
  Result := '';
  KeyWord := KeyWord + '=';
  if Pos(KeyWord, Chaine) > 0 then begin
    Delete(Chaine, 1, Pos(KeyWord, Chaine) + Length(KeyWord) -1);
    if Pos(Sep, Chaine) > 0 then Result := Copy(Chaine, 1, Pos(Sep, Chaine) -1)
                            else Result := Chaine;
  end;
end;

function CodeString(Chaine, Code: String): String;
var
  Cpt: Integer;
  n: Integer;
  s: String;
begin
  Result := '';
  if (Length(Chaine) = 0) or (Length(Code) = 0) then exit;
  s := '';
  Cpt := 1;
  for n := 1 to Length(Chaine) do begin
    s := s + Char(Ord(Chaine[n]) xor Ord(Code[Cpt]));
    Inc(Cpt);
    if Cpt > length(Code) then Cpt := 1;
  end;
  for n := 1 to length(s) do
    Result := Result + '#' + IntToStr(Ord(s[n]));
end;

function DecodeString(Chaine, Code: String): String;
var
  Cpt: Integer;
  n: Integer;
  s, s1: String;
begin
  Result := '';
  if (Length(Chaine) = 0) or (Length(Code) = 0) then exit;
  s := '';
  While Pos('#', Chaine) > 0 do begin
    Delete(Chaine, 1, Pos('#', Chaine));
    if Pos('#', Chaine) > 0 then s1 := Copy(Chaine, 1, Pos('#', Chaine) -1)
                            else s1 := Chaine;
    s := s + Char(StrToInt(s1));
  end;

  Cpt := 1;
  for n := 1 to Length(s) do begin
    Result := Result + Char(Ord(s[n]) xor Ord(Code[Cpt]));
    Inc(Cpt);
    if Cpt > length(Code) then Cpt := 1;
  end;
end;

function GetDateFromString(s: String): String;
const
  Mois: Array[1..12] of String =('janvier', 'fevrier', 'mars', 'avril', 'mai', 'juin',
                           'juillet', 'aout', 'septembre', 'octobre', 'novembre', 'decembre');
var
  n: Integer;
begin
  s := SupprimeAccent(LowerCase(s));
  s := FindAndReplaceAll(s, '1er', '1'); // Pour traiter le 1er
  for n := 1 to 12 do if pos(Mois[n], s) <> 0 then begin
    s := FindAndReplaceAll(s, Mois[n], '/' + Copy('0' + IntToStr(n), Length(IntToStr(n)), 2) + '/');
    Break;
  end;
  if Pos(',', s) <> 0 then s := Copy(s, 1, Pos(',', s) -1);
  Result := ExtendedTrim(s);
  try
    Result := DateToStr(StrToDate(Result));
  except
    // Si la date récupérée n'est pas correcte on ne renvoie rien
    Result := '';
  end
end;

procedure GetKeyWordList(Chaine, KeyWord: String; Liste: TStrings);
var
  n: Integer;
begin
  Liste.Clear;
  Chaine := LowerCase(Trim(Chaine));
  KeyWord := LowerCase(Trim(KeyWord));
  While Pos(KeyWord, Chaine) <> 0 do begin
    Delete(Chaine, 1, Pos(KeyWord, Chaine) + Length(KeyWord) -1);
    n := Pos(' ', Chaine);
    if n = 0 then n := Length(Chaine) +1;
    Liste.Add(Copy(Chaine, 1, n -1));
  end;
end;

function SupprimeCaractereNonAffichable(Texte: String): String;
var
  n: Integer;
begin
  Result := Texte;
  for n := 1 to length(Result) do
    if (Result[n] < #32) and (Result[n] <> #10) and (Result[n] <> #13) then
      Result := FindAndReplaceAll(Result, Result[n], #13#10);
end;

function SupprimeRetourChariot(Texte: String): String;
var
  n: Integer;
begin
  Result := '';
  for n := 1 to length(Texte) do 
         if Texte[n] = #10 then Result := Result + ' '
    else if Texte[n] <> #13 then Result := Result + Texte[n];
end;


procedure PositionneToutControle(MyForm: TForm; Value: Boolean);
var
  n: Integer;
begin
  //exit;
  With MyForm do begin
    for n := 0 to MyForm.ComponentCount -1 do begin
      if Value then begin
        if Components[n] is TButton then (Components[n] as TButton).Enabled := Boolean(Components[n].Tag);
        if Components[n] is TSpeedButton then (Components[n] as TSpeedButton).Enabled := Boolean(Components[n].Tag);
        if Components[n] is TToolButton then (Components[n] as TToolButton).Enabled := Boolean(Components[n].Tag);
        if Components[n] is TMenuItem then (Components[n] as TMenuItem).Enabled := Boolean(Components[n].Tag);
        if Components[n] is TDBGrid then (Components[n] as TDBGrid).Enabled := Boolean(Components[n].Tag);
        if Components[n] is TDBCheckBox then (Components[n] as TDBCheckBox).Enabled := Boolean(Components[n].Tag);
        if Components[n] is TTreeView then (Components[n] as TTreeView).Enabled := Boolean(Components[n].Tag);
      end else begin
        if Components[n] is TButton then With (Components[n] as TButton) do begin
          Tag := Integer(Enabled);
          Enabled := False;
        end;
        if Components[n] is TSpeedButton then With (Components[n] as TSpeedButton) do begin
          Tag := Integer(Enabled);
          Enabled := False;
        end;
        if Components[n] is TToolButton then With (Components[n] as TToolButton) do begin
          Tag := Integer(Enabled);
          Enabled := False;
        end;
        if Components[n] is TMenuItem then With (Components[n] as TMenuItem) do begin
          Tag := Integer(Enabled);
          Enabled := False;
        end;
        if Components[n] is TDBGrid then With (Components[n] as TDBGrid) do begin
          Tag := Integer(Enabled);
          Enabled := False;
        end;
        if Components[n] is TDBCheckBox then With (Components[n] as TDBCheckBox) do begin
          Tag := Integer(Enabled);
          Enabled := False;
        end;
        if Components[n] is TTreeView then With (Components[n] as TTreeView) do begin
          Tag := Integer(Enabled);
          Enabled := False;
        end;
      end;
    end;
  end;
end;

function GetaWordFromKey(Chaine, KeyWord, Sep: String): String;
begin
  Result := '';
  if Pos(KeyWord, Chaine) > 0 then begin
    Delete(Chaine, 1, Pos(KeyWord, Chaine) + Length(KeyWord) -1);
    if Pos(Sep, Chaine) > 0 then Result := Copy(Chaine, 1, Pos(Sep, Chaine) -1)
                            else Result := Chaine;
  end;
end;

function GetaWordFromIndex(Chaine: String; Index: Integer; Sep: String): String;
begin
  Result := '';
  if index > 0 then begin
    Delete(Chaine, 1, Index -1);
    if Pos(Sep, Chaine) > 0 then Result := Copy(Chaine, 1, Pos(Sep, Chaine) -1)
                            else Result := Chaine;
  end;
end;

function PosFrom(Substr, Str: String; Index: Integer): Integer;
var
  n: Integer;
begin
  Delete(Str, 1, Index -1);
  n := Pos(Substr, str);
  if n = 0 then Result := 0
           else Result := Index + n -1;
end;

procedure Temporisation(t: Integer);
var
  TempsMax: TDateTime;
begin
  TempsMax := Now + (t / 2246400000);
  Repeat
    Application.ProcessMessages;
  Until Now > TempsMax;
end;

function NormalizeRequetePourDB(Requete: String): String;
begin
  Result := FindAndReplaceAll(Requete, 'upper(a.tout)', 'a.tout');
  Result := FindAndReplaceAll(Result, 'upper(a.objet)', 'a.upperobjet');
  Result := FindAndReplaceAll(Result, #10, ' ');
  Result := FindAndReplaceAll(Result, #13, ' ');
  Result := FindAndReplaceAll(Result, '( ', '(');
  Result := FindAndReplaceAll(Result, ' )', ')');
  Result := FindAndReplaceAll(Result, '  ', ' ');
end;

function NormalizeRequetePourIB(Requete: String): String;
begin
  Result := FindAndReplaceAll(Requete, 'upper(a.tout)', 'a.tout');
  Result := FindAndReplaceAll(Result, #10, ' ');
  Result := FindAndReplaceAll(Result, #13, ' ');
  Result := FindAndReplaceAll(Result, '( ', '(');
  Result := FindAndReplaceAll(Result, ' )', ')');
  Result := FindAndReplaceAll(Result, '  ', ' ');
end;

function NormalizeDecimalSeparator(Value: String): String;
begin
  Result := Value;
  Result := StringReplace(Result, ',', #2, [rfReplaceAll]);
  Result := StringReplace(Result, '.', #2, [rfReplaceAll]);
  Result := StringReplace(Result, #2, DecimalSeparator, [rfReplaceAll]);
end;

function FormatMonnaieChaine(Value: String; Decimal: Byte): String;
begin
  Result := NormalizeDecimalSeparator(Value);
  if Pos(DecimalSeparator, Result) = 0 then Result := Result + DecimalSeparator;
  While (Length(Result) - Pos(DecimalSeparator, Result)) < Decimal do
    Result := Result + '0';
end;

{***************************************************************}
{                   Fonctions Gestion Disque                    }
{***************************************************************}
function VerifyDirectoryName(Var Name : String): Boolean;
begin
  Result := False;
  if trim(Name) = '' then Exit;
  Name := FindAndReplaceAll(Name, '\\', '\');
  if Name[Length(Name)] = '\' then Name := copy(Name,1,Length(Name)-1);
  if (Name[Length(Name)] = ':') then Exit;
  Result := True;
end;

procedure CheckDirectory(dir: string; CreateDir: TCreateDir);
var
  Attr: Integer;
  s: string;
  n: word;
begin
  s := LowerCase(Dir);
  s := Dir;
  if not VerifyDirectoryName(S) then Exit;
  Attr := FileGetAttr(s);
  if Attr < 0 then begin
    if CreateDir = cdirNo then
      raise Exception.create('Répertoire ' + s + ' non trouvé');
    if (CreateDir = cdirConfirm) or (CreateDir = cdirConfirmEach) then
      if BoiteMessage('Répertoire ' + s + ' non trouvé' + RC + 'Voulez vous le créer ?',
                      'Répertoire non trouvé', Mb_IconQuestion + Mb_YesNo) <> IdYes then raise Exception.create('Répertoire ' + s + ' non trouvé');

    for n := Length(s) downto 1 do begin
      if s[n] =  '\' then begin
        if (CreateDir = cdirConfirmEach) then CheckDirectory(Copy(s,1,n-1), cdirConfirmEach)
                                         else CheckDirectory(Copy(s,1,n-1), cdirYes);
        Break;
      end;
    end;
    MkDir(s);
  end
  else if (Attr and faDirectory) = 0 then raise Exception.create('Le fichier ' + s + ' n''est pas un répertoire');
end;

{ Equivalent de la commande Dir }
procedure LireDir(FileName: String; Attr: Integer; ListDir: TStrings);
var
  SearchRec: TSearchRec;
begin
  try
    ListDir.Clear;
    //PushC(crHourGlass);
    if FindFirst(FileName, Attr, SearchRec) = 0 then begin
      ListDir.Add(ExtractFilePath(FileName) + SearchRec.Name);
      While FindNext(SearchRec) = 0 do
        ListDir.Add(ExtractFilePath(FileName) + SearchRec.Name);
    end;
  finally
    Sysutils.FindClose(SearchRec);
    //PopC;
  end;
end;

function NormalizeDirectoryName(Name : String): string;
begin
  Result := Trim(Name);
  if Result = '' then Exit;
  Result := FindAndReplaceAll(Result, '\\', '\');
  if Result[Length(Result)] <> '\' then Result := Result + '\';
end;

function NormalizeFileName(Name : String): string;
begin
  Result := Name;
  Result := FindAndReplaceAll(Result, '\\', '\');
  if Length(Result) > 0 then
    if Result[Length(Result)] = '\' then Result := Copy(Result, 1,  Length(Result) -1);
end;

procedure FDCopyFiles(FileName, DestDir: String; FailIfExist: Boolean);
var
  FileList: TStringList;
  n: Integer;
begin
  VerifyDirectoryName(DestDir);
  DestDir := DestDir + '\';
  FileList := TStringList.Create;
  With FileList do try
    LireDir(FileName, faAnyFile, FileList);
    for n := 0 to count -1 do
      fb_CopyFile(Strings[n], DestDir + ExtractFileName(Strings[n]), False, FailIfExist);
  finally
    Free;
  end;
end;

procedure FDDeleteFiles(FileName: String);
var
  FileList: TStringList;
  n: Integer;
begin
  FileList := TStringList.Create;
  With FileList do try
    LireDir(FileName, faAnyFile, FileList);
    for n := 0 to count -1 do
      DeleteFile(PChar(Strings[n]));
  finally
    Free;
  end;
end;

procedure FDFileSetAttr(FileName: String; Attr: Integer);
var
  FileList: TStringList;
  n: Integer;
begin
  FileList := TStringList.Create;
  With FileList do try
    LireDir(FileName, faAnyFile, FileList);
    for n := 0 to count -1 do
      FileSetAttr(PChar(Strings[n]), Attr);
  finally
    Free;
  end;
end;

procedure FDRenameFiles(FileName, FileDest: String);
var
  FileList: TStringList;
  n: Integer;
begin
  FileList := TStringList.Create;
  FileDest := ExtractFilePath(FileDest) + ExtractFileNameBeforeExtension(FileDest);
  With FileList do try
    LireDir(FileName, faAnyFile, FileList);
    for n := 0 to count -1 do
      RenameFile(Strings[n], FileDest + ExtractFileExt(Strings[n]));
  finally
    Free;
  end;
end;

procedure DemanderConfirmationSiFichierExiste(FileName: String);
begin
  if FileExists(FileName) then
    if BoiteMessage('Le fichier "' + ExtractFileName(FileName) + '" existe déja.' + RC
                  + 'Ecraser ?', 'Fichier existant', Mb_IconQuestion + Mb_YesNo + mb_DefButton2) <> IdYes then Abort;
end;

procedure GetFile(DirName, FileMask: String; Attr: Integer; ListDir: TStrings);
    // Lit la liste des dossiers
    procedure GetDirList(DirName: String; DirList: TStrings);
    var
      SearchRec: TSearchRec;
    begin
      try
        if FindFirst(DirName + '*.*', faAnyFile , SearchRec) = 0 then begin
          if ((SearchRec.Attr and faDirectory) <> 0) and(SearchRec.Name <> '..') and (SearchRec.Name <> '.') then begin
            DirList.Add(NormalizeDirectoryName(DirName + SearchRec.Name));
            GetDirList(NormalizeDirectoryName(DirName + SearchRec.Name), DirList)
          end;
          While FindNext(SearchRec) = 0 do begin
            if ((SearchRec.Attr and faDirectory) <> 0) and (SearchRec.Name <> '..') and (SearchRec.Name <> '.') then begin
              DirList.Add(NormalizeDirectoryName(DirName + SearchRec.Name));
              GetDirList(NormalizeDirectoryName(DirName + SearchRec.Name), DirList)
            end;
          end;
        end;
      finally
        Sysutils.FindClose(SearchRec);
      end;
    end;

    // Lit les fichiers d'un dossier
    procedure GetFileOfDir(DirName: String; Attr: Integer; FileList: TStrings);
    var
      SearchRec: TSearchRec;
    begin
      try
        if FindFirst(DirName, Attr, SearchRec) = 0 then begin
          if ((SearchRec.Attr and faDirectory) = 0) and (SearchRec.Name <> '..') and (SearchRec.Name <> '.') then begin
            FileList.Add(ExtractFilePath(DirName) + SearchRec.Name);
          end;
          While FindNext(SearchRec) = 0 do begin
            if ((SearchRec.Attr and faDirectory) = 0) and (SearchRec.Name <> '..') and (SearchRec.Name <> '.') then begin
              FileList.Add(ExtractFilePath(DirName) + SearchRec.Name);
            end;
          end;
        end;
      finally
        Sysutils.FindClose(SearchRec);
      end;
    end;

var
  DirList: TStringList;
  n: Integer;
begin
  DirList := TStringList.Create;
  try
    PushC(crHourGlass);
    GetFileOfDir(DirName + FileMask, Attr, ListDir);
    GetDirList(DirName, DirList);
    With DirList do
      for n := 0 to count -1 do
        GetFileOfDir(Strings[n] + FileMask, Attr, ListDir);
  finally
    DirList.Free;
    PopC;
  end;
end;



{***************************************************************}
{                   Fonctions Curseur Souris                    }
{***************************************************************}
procedure PushC(MCursor : TCursor);
begin
  PushCursor[MSIndex] := Screen.Cursor;
  MSIndex := MSIndex + 1;
  Screen.Cursor := MCursor;
end;

procedure PopC;
begin
  if MSIndex <> 0 then begin
    MSIndex := MSIndex - 1;
    Screen.Cursor := PushCursor[MSIndex];
  end;
end;



procedure DrawCheckBox(Canvas: TCanvas; Rect: TRect);
begin
  With Canvas do begin
    Brush.Color := clWindow;
    FillRect(Rect);
    Pen.Color := ClGrayText;
    MoveTo(Rect.Left, Rect.Bottom);
    LineTo(Rect.Left, Rect.Top);
    LineTo(Rect.Right, Rect.Top);
    Pen.Color := ClBlack;
    MoveTo(Rect.Left +1, Rect.Bottom);
    LineTo(Rect.Left +1, Rect.Top +1);
    LineTo(Rect.Right -1, Rect.Top +1);
    Pen.Color := ClWhite;
    LineTo(Rect.Right -1, Rect.Top +1);
    LineTo(Rect.Right -1, Rect.Bottom -1);
    LineTo(Rect.Left, Rect.Bottom -1);
    Pen.Color := ClBtnFace;
    MoveTo(Rect.Right -2, Rect.Top +2);
    LineTo(Rect.Right -2, Rect.Bottom -2);
    LineTo(Rect.Left, Rect.Bottom -2);



//    Rectangle(Rect);
  end;
end;


function Arrondie(Value: Double; Decimal: Byte): Double;
var
  Mult: Integer;
  n: Byte;
begin
  Mult := 1;
  for n := 1 to Decimal do Mult := Mult * 10;
  Result := Round(Value * Mult) / Mult;
end;



end.