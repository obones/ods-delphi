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
  ods.Treap in '..\sources\ods.Treap.pas',
  ods.ScapegoatTree.Tests in 'ods.ScapegoatTree.Tests.pas',
  ods.ScapegoatTree in '..\sources\ods.ScapegoatTree.pas',
  PerformanceTests in 'PerformanceTests.pas',
  ods.ArrayStack in '..\sources\ods.ArrayStack.pas',
  ods.ChainedHashTable.Tests in 'ods.ChainedHashTable.Tests.pas',
  ods.ChainedHashTable in '..\sources\ods.ChainedHashTable.pas',
  ods.LinearHashTable.Tests in 'ods.LinearHashTable.Tests.pas',
  ods.LinearHashTable in '..\sources\ods.LinearHashTable.pas',
  ods.Base.Tests in 'ods.Base.Tests.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

