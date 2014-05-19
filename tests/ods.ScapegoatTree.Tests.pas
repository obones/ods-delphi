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
{ The Original Code is ods.ScapegoatTree.Tests.pas.                                                }
{                                                                                                  }
{ The Initial Developer of the Original Code is Olivier Sannier (obones).                          }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{ Contributors:                                                                                    }
{                                                                                                  }
{**************************************************************************************************}
unit ods.ScapegoatTree.Tests;

interface

uses
  ods.BinarySearchTree.Tests, ods.ScapegoatTree;

type
  TScapegoatTreeTest<T; N: TScapegoatNode<T>, constructor; TTree: TScapegoatTree<T, N>, constructor> = class(TBinarySearchTreeTest<T, N, TTree>)
  end;

  TIntegerScapegoatTreeTest = class(TBinarySearchTreeTest<Integer, TScapegoatNode<Integer>, TScapegoatTree<Integer, TScapegoatNode<Integer>>>)
  protected
    function GetAddValue: Integer; override;
    procedure DoTestAddChecks(Value: Integer); override;
  end;

implementation

{ TIntegerScapegoatTreeTest }

procedure TIntegerScapegoatTreeTest.DoTestAddChecks(Value: Integer);
begin
  inherited DoTestAddChecks(Value);

  CheckEquals(89, FTree.Find(Value), 'Value should be there');
end;

function TIntegerScapegoatTreeTest.GetAddValue: Integer;
begin
  Result := 89;
end;

end.


