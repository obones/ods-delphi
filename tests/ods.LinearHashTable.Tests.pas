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
{ The Original Code is ods.LinearHashTable.Tests.pas.                                              }
{                                                                                                  }
{ The Initial Developer of the Original Code is Olivier Sannier (obones).                          }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{ Contributors:                                                                                    }
{                                                                                                  }
{**************************************************************************************************}
unit ods.LinearHashTable.Tests;

interface

uses
  ods.Base.Tests,
  ods.LinearHashTable;

type
  TLinearHashTableTest<T; Table: TLinearHashTable<T>, constructor> = class(TBaseTest<Table>)
  protected
    function GetAddValue: T; virtual; abstract;
    procedure DoTestAddChecks; virtual;
  published
    procedure TestAdd;
  end;

  TIntegerLinearHashTable = class(TLinearHashTable<Integer>)
  protected
    function hashCode(x: Integer): Cardinal; override;
  end;

  TIntegerLinearHashTableTest = class(TLinearHashTableTest<Integer, TIntegerLinearHashTable>)
  protected
    function GetNewObject: TIntegerLinearHashTable; override;

    function GetAddValue: Integer; override;
    procedure DoTestAddChecks; override;
  end;

implementation

{ TLinearHashTableTest<T, Table> }

procedure TLinearHashTableTest<T, Table>.DoTestAddChecks;
begin
  CheckEquals(1, FObject.Size, 'Size');
end;

procedure TLinearHashTableTest<T, Table>.TestAdd;
begin
  FObject.Add(GetAddValue);

  DoTestAddChecks;
end;

{ TIntegerLinearHashTable }

function TIntegerLinearHashTable.hashCode(x: Integer): Cardinal;
begin
  Result := Cardinal(x);
end;

{ TIntegerLinearHashTableTest }

procedure TIntegerLinearHashTableTest.DoTestAddChecks;
begin
  inherited DoTestAddChecks;

  CheckEquals(45, FObject.Find(45), 'Find');
end;

function TIntegerLinearHashTableTest.GetAddValue: Integer;
begin
  Result := 45;
end;

function TIntegerLinearHashTableTest.GetNewObject: TIntegerLinearHashTable;
begin
  Result := TIntegerLinearHashTable.Create(0, -1);
end;

end.
