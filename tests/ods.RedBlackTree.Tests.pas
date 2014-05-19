unit ods.RedBlackTree.Tests;

interface

uses
  ods.BinarySearchTree.Tests, ods.RedBlackTree;

type
  TRedBlackTreeTest<T; N: TRedBlackNode<T>, constructor; TTree: TRedBlackTree<T, N>, constructor> = class(TBinarySearchTreeTest<T, N, TTree>)
  end;

  TIntegerRedBlackTreeTest = class(TBinarySearchTreeTest<Integer, TRedBlackNode<Integer>, TRedBlackTree<Integer, TRedBlackNode<Integer>>>)
  protected
    function GetAddValue: Integer; override;
    procedure DoTestAddChecks(Value: Integer); override;
  end;

implementation

{ TIntegerRedBlackTreeTest }

procedure TIntegerRedBlackTreeTest.DoTestAddChecks(Value: Integer);
begin
  inherited DoTestAddChecks(Value);

  CheckEquals(57, FTree.Find(Value), 'Value should be there');
end;

function TIntegerRedBlackTreeTest.GetAddValue: Integer;
begin
  Result := 57;
end;

end.
