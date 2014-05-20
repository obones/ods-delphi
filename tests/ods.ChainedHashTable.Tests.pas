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
{ The Original Code is ods.ChainedHashTable.Tests.pas.                                             }
{                                                                                                  }
{ The Initial Developer of the Original Code is Olivier Sannier (obones).                          }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{ Contributors:                                                                                    }
{                                                                                                  }
{**************************************************************************************************}
unit ods.ChainedHashTable.Tests;

interface

uses
  ods.Base.Tests,
  ods.ChainedHashTable;

type
  TChainedHashTableTest<T; Table: TChainedHashTable<T>, constructor> = class(TBaseTest<Table>)
  protected
    function GetAddValue: T; virtual; abstract;
    procedure DoTestAddChecks; virtual;
  published
    procedure TestAdd;
  end;

  TIntegerChainedHashTable = class(TChainedHashTable<Integer>)
  protected
    function hashCode(x: Integer): Cardinal; override;
  end;

  TIntegerChainedHashTableTest = class(TChainedHashTableTest<Integer, TIntegerChainedHashTable>)
  protected
    function GetAddValue: Integer; override;
    procedure DoTestAddChecks; override;
  end;

implementation

{ TChainedHashTableTest<T, Table> }

procedure TChainedHashTableTest<T, Table>.DoTestAddChecks;
begin
  CheckEquals(1, FObject.Size, 'Size');
end;

procedure TChainedHashTableTest<T, Table>.TestAdd;
begin
  FObject.Add(GetAddValue);

  DoTestAddChecks;
end;

{ TIntegerChainedHashTableTest }

procedure TIntegerChainedHashTableTest.DoTestAddChecks;
begin
  inherited DoTestAddChecks;

  CheckEquals(45, FObject.Find(45), 'Find');
end;

function TIntegerChainedHashTableTest.GetAddValue: Integer;
begin
  Result := 45;
end;

{ TIntegerChainedHashTable }

function TIntegerChainedHashTable.hashCode(x: Integer): Cardinal;
begin
  Result := Cardinal(x);
end;

end.
