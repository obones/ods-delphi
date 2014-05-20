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
{ The Original Code is Registration.pas.                                                           }
{                                                                                                  }
{ The Initial Developer of the Original Code is Olivier Sannier (obones).                          }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{ Contributors:                                                                                    }
{                                                                                                  }
{**************************************************************************************************}
unit Registration;

interface

implementation

uses
  TestFramework,
  ods.BinaryTree.Tests,
  ods.BinarySearchTree.Tests,
  ods.RedBlackTree.Tests,
  ods.Treap.Tests,
  ods.ScapegoatTree.Tests,
  ods.ChainedHashTable.Tests,
  ods.LinearHashTable.Tests,
  PerformanceTests;

procedure RegisterTests;
begin
  RegisterTest(TTestSuite.Create('Trees',
    [
      TBinaryTreeTest.Suite,
      TIntegerBinarySearchTreeTest.Suite,
      TIntegerRedBlackTreeTest.Suite,
      TIntegerTreapTest.Suite,
      TIntegerScapegoatTreeTest.Suite
    ]));

  RegisterTest(TTestSuite.Create('Hashes',
    [
      TIntegerChainedHashTableTest.Suite,
      TIntegerLinearHashTableTest.Suite
    ]));

  RegisterTest(TTestSuite.Create('Performances', [TTreesPerformanceTest.Suite]));
end;

initialization
  RegisterTests;

end.