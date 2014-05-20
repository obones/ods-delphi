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
