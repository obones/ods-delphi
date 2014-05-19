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
{ The Original Code is ods.BinaryTree.Tests.pas.                                                   }
{                                                                                                  }
{ The Initial Developer of the Original Code is Olivier Sannier (obones).                          }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{ Contributors:                                                                                    }
{                                                                                                  }
{**************************************************************************************************}
unit ods.BinaryTree.Tests;

interface

uses
  TestFramework,
  ods.BinaryTree;

type
  TBinaryTreeTest<N: TBTNode; T: TBinaryTree<N>, constructor> = class(TTestCase)
  private
    FTree: T;
  protected
    function GetNewObject: T; virtual;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSize;
  end;

  TBinaryTreeTest = class(TBinaryTreeTest<TBTNode, TBinaryTree<TBTNode>>)
  end;

implementation

{ TBinaryTreeTest<N, T> }

function TBinaryTreeTest<N, T>.GetNewObject: T;
begin
  Result := T.Create;
end;

procedure TBinaryTreeTest<N, T>.SetUp;
begin
  inherited SetUp;

  FTree := GetNewObject;
end;

procedure TBinaryTreeTest<N, T>.TearDown;
begin
  FTree.Free;

  inherited TearDown;
end;

procedure TBinaryTreeTest<N, T>.TestSize;
begin
  CheckEquals(0, FTree.Size, 'Size should be 0 at first');
end;

end.
