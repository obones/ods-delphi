program ODSTests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  ods.BinaryTree.Tests in 'ods.BinaryTree.Tests.pas',
  ods.BinaryTree in '..\sources\ods.BinaryTree.pas',
  Registration in 'Registration.pas',
  ods.ArrayDeque in '..\sources\ods.ArrayDeque.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

