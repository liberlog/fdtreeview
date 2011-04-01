{ Ce fichier a été automatiquement créé par Lazarus. Ne pas l'éditer !
  Cette source est seulement employée pour compiler et installer le paquet.
 }

unit lfdtreeview; 

interface

uses
  regfdtreeview, FDTreeView, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('regfdtreeview', @regfdtreeview.Register); 
end; 

initialization
  RegisterPackage('lfdtreeview', @Register); 
end.
