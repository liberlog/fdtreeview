program fdtreedemo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, u_formfd, lfdtreeview, LResources
  { you can add units after this };

{$IFDEF WINDOWS}{$R fdtreedemo.rc}{$ENDIF}

begin
  {$I fdtreedemo.lrs}
  Application.Initialize;
  Application.CreateForm(Tformfd,formfd);
  Application.Run;
end.

