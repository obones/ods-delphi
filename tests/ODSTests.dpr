program ODSTests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  ods.BinaryTree.Tests in 'ods.BinaryTree.Tests.pas',
  ods.BinaryTree in '..\sources\ods.BinaryTree.pas',
  Registration in 'Registration.pas',
  ods.ArrayDeque in '..\sources\ods.ArrayDeque.pas',
  ods.BinarySearchTree in '..\sources\ods.BinarySearchTree.pas',
  ods.BinarySearchTree.Tests in 'ods.BinarySearchTree.Tests.pas',
  ods.RedBlackTree in '..\sources\ods.RedBlackTree.pas',
  ods.RedBlackTree.Tests in 'ods.RedBlackTree.Tests.pas',
  ods.Treap.Tests in 'ods.Treap.Tests.pas',
  ods.Treap in '..\sources\ods.Treap.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

