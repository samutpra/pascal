program HelloConsole;

{$mode objfpc}{$H+}

uses
  SysUtils;

var
  Name: string;

begin
  if ParamCount > 0 then
    Name := ParamStr(1)
  else
    Name := 'World';

  WriteLn(Format('Hello, %s!', [Name]));
  WriteLn('Free Pascal ', {$I %FPCVERSION%}, ' on ', {$I %FPCTARGETOS%}, '-', {$I %FPCTARGETCPU%});
end.
