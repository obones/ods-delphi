{**************************************************************************************************}
{                                                                                                  }
{ ODS-Delphi                                                                                       }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 2.0 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is ods.RedBlackTree.Tests.pas.                                                 }
{                                                                                                  }
{ The Initial Developer of the Original Code is Olivier Sannier (obones).                          }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{ Contributors:                                                                                    }
{                                                                                                  }
{**************************************************************************************************}
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