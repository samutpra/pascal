unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFormMain }

  TFormMain = class(TForm)
    ButtonHello: TButton;
    LabelMessage: TLabel;
    procedure ButtonHelloClick(Sender: TObject);
  private

  public

  end;

var
  FormMain: TFormMain;

implementation

{$R *.lfm}

{ TFormMain }

procedure TFormMain.ButtonHelloClick(Sender: TObject);
begin
  LabelMessage.Caption := 'Hello, World!';
end;

end.
