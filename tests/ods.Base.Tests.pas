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
{ The Original Code is ods.Base.Tests.pas.                                                         }
{                                                                                                  }
{ The Initial Developer of the Original Code is Olivier Sannier (obones).                          }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{ Contributors:                                                                                    }
{                                                                                                  }
{**************************************************************************************************}
unit ods.Base.Tests;

interface

uses
  TestFramework,
  ods.BinaryTree;

type
  TBaseTest<T: class, constructor> = class(TTestCase)
  private
    FObject: T;
  protected
    function GetNewObject: T; virtual;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  end;

implementation

{ TBaseTest<T> }

function TBaseTest<T>.GetNewObject: T;
begin
  Result := T.Create;
end;

procedure TBaseTest<T>.SetUp;
begin
  inherited SetUp;

  FObject := GetNewObject;
end;

procedure TBaseTest<T>.TearDown;
begin
  FObject.Free;

  inherited TearDown;
end;

end.
