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
{ The Original Code is ods.ArrayStack.pas.                                                         }
{                                                                                                  }
{ The Initial Developer of the Original Code is Olivier Sannier (obones).                          }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{ Contributors:                                                                                    }
{                                                                                                  }
{**************************************************************************************************}
unit ods.ArrayStack;

interface

type
  TArrayStack<T> = class
  protected
    a: TArray<T>;
    n: Integer;
    procedure resize();
  public
    constructor Create;

    function Size(): Integer; inline;
    function GetItem(i: Integer): T; inline;
    function SetItem(i: Integer; x: T): T; inline;
    procedure Add(i: Integer; x: T); overload;
    procedure Add(x: T); overload; inline; { add(size(), x); }
    function Remove(i: Integer): T;
    procedure Clear();
  end;

implementation

uses
  System.Math;

{ TArrayStack<T> }

procedure TArrayStack<T>.Add(i: Integer; x: T);
var
  j: Integer;
begin
  if n + 1 > Length(a) then
    resize();
  for j := n downto i + 1 do
    a[j] := a[j - 1];
  a[i] := x;
  Inc(n);
end;

procedure TArrayStack<T>.Add(x: T);
begin
  Add(Size, x);
end;

procedure TArrayStack<T>.Clear;
begin
  n := 0;
  SetLength(a, 0);
end;

constructor TArrayStack<T>.Create;
begin
  inherited Create;

  n := 0;
end;

function TArrayStack<T>.GetItem(i: Integer): T;
begin
  Result := a[i];
end;

function TArrayStack<T>.Remove(i: Integer): T;
var
  j: Integer;
begin
  Result := a[i];
  for j := i to n do
    a[j] := a[j + 1];
  Dec(n);
  if Length(a) >= 3 * n then
    resize();
end;

procedure TArrayStack<T>.resize;
begin
  SetLength(a, max(2 * n, 1));
end;

function TArrayStack<T>.SetItem(i: Integer; x: T): T;
begin
  Result := a[i];
  a[i] := x;
end;

function TArrayStack<T>.Size: Integer;
begin
  Result := n;
end;

end.