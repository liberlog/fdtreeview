unit regfdtreeview;

{$IFDEF FPC}
{$Mode Delphi}
{$ENDIF}

{
Integrated in Freelogy Project
Portage to LAZARUS : Matthieu GIROUX - www.liberlog.fr
}


interface

uses
  Classes,
{$IFDEF FPC}
  lresources,
{$ENDIF}
  SysUtils ;
procedure Register;

implementation

uses FDTreeview;

{----------------------------------------------------------}
{ Enregistre le composant }
procedure Register;
begin
  RegisterComponents('FD Components', [TFDTreeView]);
end;

{$IFDEF FPC}
initialization
{$i regfdtreeview.lrs}
{$ENDIF}
end.

