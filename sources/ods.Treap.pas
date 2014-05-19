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
{ The Original Code is ods.Treap.pas.                                                              }
{                                                                                                  }
{ The Initial Developer of the Original Code is Olivier Sannier (obones).                          }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{ Contributors:                                                                                    }
{                                                                                                  }
{**************************************************************************************************}
unit ods.Treap;

interface

uses
  ods.BinarySearchTree;

type
  TTreapNode<T> = class (TBSTNode<T>)
  protected
    p: Integer;
  end;

  TTreap<T; TNode: TTreapNode<T>, constructor> = class(TBinarySearchTree<T, TNode>)
  protected
    procedure bubbleUp(u: TNode);
    procedure trickleDown(u: TNode);
  public
    function Add(x: T): Boolean; override;
    function Remove(x :T): Boolean; override;

    (**
     * Warning - you can not call size() on the original treap or the new treap
     * after calling this method
     *)
    function Split(x: T): TTreap<T, TNode>;

    {**
     * Absorb the elements of treap t, which should all be smaller than
     * all the elements in this
     * @param t
     * @return
     *}
    procedure Absorb(t: TTreap<T, TNode>);
  end;


implementation

{ TTreap<T, TNode> }

procedure TTreap<T, TNode>.Absorb(t: TTreap<T, TNode>);
var
  s: TNode;
begin
  s := TNode.Create;
  s.right := Self.r;
  if Self.r <> nil then
    TNode(Self.r).parent := s;
  s.left := t.r;
  if t.r <> nil then
    TNode(t.r).parent := s;

  Self.r := s;
  t.r := nil;
  trickleDown(s);
  splice(s);
end;

function TTreap<T, TNode>.Add(x: T): Boolean;
var
  u: TNode;
begin
  u := TNode.Create;
  u.x := x;
  u.p := random(MaxInt);
  if inherited addNode(u) then
  begin
    bubbleUp(u);
    Exit(true);
  end;
  Result := false;
end;

procedure TTreap<T, TNode>.bubbleUp(u: TNode);
begin
  while (u.parent <> nil) and (TNode(u.parent).p > u.p) do
  begin
    if TNode(u.parent.right) = u then
      rotateLeft(TNode(u.parent))
    else
      rotateRight(TNode(u.parent));
  end;
  if u.parent = nil then
    r := u;
end;

function TTreap<T, TNode>.Remove(x: T): Boolean;
var
  u: TNode;
begin
  u := findLast(x);
  if (u <> nil) and (compare(u.x, x) = 0) then
  begin
    trickleDown(u);
    splice(u);
    u.Free;
    Exit(true);
  end;
  Result := false;
end;

function TTreap<T, TNode>.Split(x: T): TTreap<T, TNode>;
var
  u: TNode;
  s: TNode;
begin
  u := findLast(x);
  s := TNode.Create();
  if u.right = nil then
  begin
    u.right := s;
  end
  else
  begin
    u := TNode(u.right);
    while u.left <> nil do
      u := TNode(u.left);
    u.left := s;
  end;
  s.parent := u;
  s.p := Low(s.p);
  bubbleUp(s);
  Self.r := TNode(s.right);
  if Self.r <> nil then
    TNode(Self.r).parent := nil;
  n := Low(n);
  Result := TTreap<T, TNode>.Create;
  Result.r := TNode(s.left);
  if Result.r <> nil then
    TNode(Result.r).parent := nil;
  n := Low(n);
end;

procedure TTreap<T, TNode>.trickleDown(u: TNode);
begin
  while (u.left <> nil) or (u.right <> nil) do
  begin
    if u.left = nil then
      rotateLeft(u)
    else if u.right = nil then
      rotateRight(u)
    else if TNode(u.left).p < TNode(u.right).p then
      rotateRight(u)
    else
      rotateLeft(u);

    if r = u then
      r := TNode(u.parent);
  end;
end;

end.