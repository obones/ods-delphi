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
{ The Original Code is ods.ArrayDeque.pas.                                                         }
{                                                                                                  }
{ The Initial Developer of the Original Code is Olivier Sannier (obones).                          }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{ Contributors:                                                                                    }
{                                                                                                  }
{**************************************************************************************************}
unit ods.ArrayDeque;

interface

type
  TArrayDeque<T> = class
  protected
    a: TArray<T>;
    j: Integer;
    n: Integer;
    procedure resize();
  public
    constructor Create;
    destructor Destroy; override;

    function size: Integer;
    function getItem(i: Integer): T;
    function setItem(i: Integer; x: T): T;

    procedure add(i: Integer; x: T); virtual;
    function remove(i: Integer): T; virtual;
    procedure clear; virtual;
  end;

implementation

uses
  System.Math;

{ TArrayDeque<T> }

procedure TArrayDeque<T>.add(i: Integer; x: T);
var
  k: Integer;
begin
  if n + 1 > Length(a) then
    resize();
  if i < n div 2 then
  begin // shift a[0],..,a[i-1] left one position
    if j = 0 then
      j := Length(a) - 1
    else
      j := j - 1;

    for k := 0 to i-1 do
      a[(j+k) mod Length(a)] := a[(j+k+1) mod Length(a)];
  end
  else
  begin // shift a[i],..,a[n-1] right one position
    for k := n downto i + 1 do
      a[(j+k) mod Length(a)] := a[(j+k-1) mod Length(a)];
  end;
  a[(j+i) mod Length(a)] := x;
  Inc(n);
end;

procedure TArrayDeque<T>.clear;
begin
  n := 0;
  j := 0;
  SetLength(a, 1);
end;

constructor TArrayDeque<T>.Create;
begin
  n := 0;
  j := 0;

  SetLength(a, 1);
end;

destructor TArrayDeque<T>.Destroy;
begin

  inherited Destroy;
end;

function TArrayDeque<T>.getItem(i: Integer): T;
begin
  Result := a[(j + i) mod Length(a)];
end;

function TArrayDeque<T>.remove(i: Integer): T;
var
  k: Integer;
begin
  Result := a[(j+i) mod Length(a)];
  if i < n/2 then // shift a[0],..,[i-1] right one position
  begin
    for k := i downto 1 do
      a[(j+k) mod Length(a)] := a[(j+k-1) mod Length(a)];
    j := (j + 1) mod Length(a);
  end
  else
  begin // shift a[i+1],..,a[n-1] left one position
    for k := i to n-2 do
      a[(j+k) mod Length(a)] := a[(j+k+1) mod Length(a)];
  end;
  Dec(n);

  if 3*n < Length(a) then
   resize();
end;

procedure TArrayDeque<T>.resize;
begin
  SetLength(a, max(1, 2*n));
  j := 0;
end;

function TArrayDeque<T>.setItem(i: Integer; x: T): T;
begin
  Result := a[(j + i) mod Length(a)];
  a[(j + i) mod Length(a)] := x;
end;

function TArrayDeque<T>.size: Integer;
begin
  Result := n;
end;

end.