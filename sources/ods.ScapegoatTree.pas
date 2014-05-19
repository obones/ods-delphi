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
{ The Original Code is ods.ScapegoatTree.pas.                                                      }
{                                                                                                  }
{ The Initial Developer of the Original Code is Olivier Sannier (obones).                          }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{ Contributors:                                                                                    }
{                                                                                                  }
{**************************************************************************************************}
unit ods.ScapegoatTree;

interface

uses
  ods.BinarySearchTree;

type
  TScapegoatNode<T> = class(TBSTNode<T>)
  end;

  TScapegoatTree<T; TNode: TScapegoatNode<T>, constructor> = class(TBinarySearchTree<T, TNode>)
  private
    const
      log23: Double = 2.4663034623764317;
  protected
    q: Integer;

    class function log32(q: Integer): Integer;

    function addWithDepth(u: TNode): Integer;
    procedure rebuild(u: TNode);
    function packIntoArray(u: TNode; var a: TArray<TNode>; i: Integer): Integer;
    function buildBalanced(const a: TArray<TNode>; i: Integer; ns: Integer): TNode;
  public
    function Add(x: T): Boolean; override;
    function Remove(x: T): Boolean; override;
  end;

implementation

uses
  System.Math;

{ TScapegoatTree<T, TNode> }

function TScapegoatTree<T, TNode>.Add(x: T): Boolean;
var
  u: TNode;
  d: Integer;
  w: TNode;
  a: Integer;
  b: Integer;
begin
	// first do basic insertion keeping track of depth
	u := TNode.Create;
	u.x := x;
	u.left := nil;
  u.right := nil;
  u.parent := nil;
	d := addWithDepth(u);

	if (d > log32(q)) then
  begin
		// depth exceeded, find scapegoat
		w := TNode(u.parent);
		a := NodeSize(w);
		b := NodeSize(TNode(w.parent));
		while 3*a <= 2*b do
    begin
			w := TNode(w.parent);
			a := NodeSize(w);
			b := NodeSize(TNode(w.parent));
		end;
		rebuild(TNode(w.parent));
	end;
	Result := d >= 0;
end;

function TScapegoatTree<T, TNode>.addWithDepth(u: TNode): Integer;
var
  w: TNode;
  done: Boolean;
  res: Integer;
begin
	w := r;
	if w = nil then
  begin
		r := u;
		Inc(n);
    Inc(q);
		Exit(0);
	end;
	done := false;
	Result := 0;
	repeat
		res := compare(u.x, w.x);
		if res < 0 then
    begin
			if w.left = nil then
      begin
				w.left := u;
				u.parent := w;
				done := true;
			end
      else
      begin
				w := TNode(w.left);
			end
		end
    else if res > 0 then
    begin
			if w.right = nil then
      begin
				w.right := u;
				u.parent := w;
				done := true;
			end;
			w := TNode(w.right);
		end
    else
    begin
			Exit(-1);
		end;
		Inc(Result);
	until done;
	Inc(n);
  Inc(q);
end;

function TScapegoatTree<T, TNode>.buildBalanced(const a: TArray<TNode>; i, ns: Integer): TNode;
var
  m: Integer;
begin
	if ns = 0 then
		Exit(nil);

	m := ns div 2;
	a[i + m].left := buildBalanced(a, i, m);
	if a[i + m].left <> nil then
		a[i + m].left.parent := a[i + m];
	a[i + m].right := buildBalanced(a, i + m + 1, ns - m - 1);
	if a[i + m].right <> nil then
		a[i + m].right.parent := a[i + m];

	Result := a[i + m];
end;

class function TScapegoatTree<T, TNode>.log32(q: Integer): Integer;
begin
	Result := Ceil(log23*Ln(q));
end;

function TScapegoatTree<T, TNode>.packIntoArray(u: TNode; var a: TArray<TNode>; i: Integer): Integer;
begin
	if u = nil then
		Exit(i);

	i := packIntoArray(TNode(u.left), a, i);
	a[i] := u;
  Inc(i);
	Result := packIntoArray(TNode(u.right), a, i);
end;

procedure TScapegoatTree<T, TNode>.rebuild(u: TNode);
var
  ns: Integer;
  p: TNode;
  a: TArray<TNode>;
begin
	ns := NodeSize(u);

	p := TNode(u.parent);
	SetLength(a, ns);
	packIntoArray(u, a, 0);
	if p = nil then
  begin
		r := buildBalanced(a, 0, ns);
		r.parent := nil;
	end
  else if TNode(p.right) = u then
  begin
		p.right := buildBalanced(a, 0, ns);
		p.right.parent := p;
	end
  else
  begin
		p.left := buildBalanced(a, 0, ns);
		p.left.parent := p;
	end
end;

function TScapegoatTree<T, TNode>.Remove(x: T): Boolean;
begin
	if inherited Remove(x) then
  begin
		if 2*n < q then
    begin
			rebuild(r);
			q := n;
		end;
		Exit(true);
	end;
	Result := false;
end;

end.
