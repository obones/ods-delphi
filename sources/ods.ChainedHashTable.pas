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
{ The Original Code is ods.ChainedHashTable.pas.                                                         }
{                                                                                                  }
{ The Initial Developer of the Original Code is Olivier Sannier (obones).                          }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{ Contributors:                                                                                    }
{                                                                                                  }
{**************************************************************************************************}
unit ods.ChainedHashTable;

interface

uses
  System.Generics.Defaults,
  ods.ArrayStack;

type
  TChainedHashTable<T> = class
  private
    FComparer: IComparer<T>;
  protected
    type TList = TArrayStack<T>;
  protected
    table: TArray<TList>;
    n: Integer;
    d: Integer;
    z: Integer;
    const
      w = 32; //sizeof(int)*8;

    procedure allocTable(m: Integer);
    procedure resize();
    function hash(x: T): Integer; inline;

    function SameValue(Left, Right: T): Boolean; inline;
    function hashCode(x: T): Cardinal; virtual;
  public
    constructor Create; overload;
    constructor Create(AComparer: IComparer<T>); overload;

    function Add(x: T): Boolean;
    function Remove(x: T): T;
    function Find(x: T): T;
    function Size(): Integer; inline;
    procedure Clear;
  end;

implementation

uses
  System.SysUtils;

{ TChainedHashTable<T> }

function TChainedHashTable<T>.Add(x: T): Boolean;
begin
  if SameValue(find(x), x) then
    Exit(false);
  if n+1 > Length(table) then
    resize();
  table[hash(x)].add(x);
  Inc(n);
  Result := true;
end;

procedure TChainedHashTable<T>.allocTable(m: Integer);
begin
  raise ENotImplemented.Create('allocTable is not implemented');
end;

procedure TChainedHashTable<T>.Clear;
begin
  n := 0;
  d := 1;
  SetLength(table, 2);
end;

constructor TChainedHashTable<T>.Create(AComparer: IComparer<T>);
begin
  inherited Create;

  FComparer := AComparer;

  Clear;
  z := random(MaxInt) or 1;     // is a random odd integer
end;

function TChainedHashTable<T>.SameValue(Left, Right: T): Boolean;
begin
  Result := FComparer.Compare(Left, Right) = 0;
end;

constructor TChainedHashTable<T>.Create;
begin
  Create(TComparer<T>.Default);
end;

function TChainedHashTable<T>.Find(x: T): T;
var
  j: Integer;
  i: Integer;
begin
  j := hash(x);
  for i := 0 to table[j].size() - 1 do
    if SameValue(x, table[j].getItem(i)) then
      Exit(table[j].getItem(i));
  Result := Default(T);
end;

function TChainedHashTable<T>.hash(x: T): Integer;
begin
  {$OVERFLOWCHECKS OFF}
  Result := (Cardinal(z) * hashCode(x)) shr (w-d);
end;

function TChainedHashTable<T>.hashCode(x: T): Cardinal;
begin
  raise EAbstractError.CreateFmt('hashCode is not implemented in %s', [ClassName]);
end;

function TChainedHashTable<T>.Remove(x: T): T;
var
  j: Integer;
  i: Integer;
begin
  j := hash(x);
  for i := 0 to table[j].size() - 1 do
  begin
    Result := table[j].getItem(i);
    if SameValue(x, Result) then
    begin
      table[j].remove(i);
      Dec(n);
      Exit;
    end;
  end;
  Result := Default(T);
end;

procedure TChainedHashTable<T>.resize;
var
  newTable: TArray<TList>;
  i: Integer;
  j: Integer;
  x: T;
begin
  d := 1;
  while 1 shl d <= n do
    Inc(d);

  n := 0;

  SetLength(newTable, 1 shl d);
  for i := 0 to Length(table) - 1 do
  begin
    for j := 0 to table[i].size() - 1 do
    begin
      x := table[i].getItem(j);
      newTable[hash(x)].add(x);
    end;
  end;
  table := newTable;
end;

function TChainedHashTable<T>.Size: Integer;
begin
  Result := n;
end;

end.