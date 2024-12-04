program fcm_pr;

uses
  Vcl.Forms,
  fcm_unit in 'fcm_unit.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
