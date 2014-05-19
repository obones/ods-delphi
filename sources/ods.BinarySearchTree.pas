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
{ The Original Code is ods.BinarySearchTree.pas.                                                   }
{                                                                                                  }
{ The Initial Developer of the Original Code is Olivier Sannier (obones).                          }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{ Contributors:                                                                                    }
{                                                                                                  }
{**************************************************************************************************}
unit ods.BinarySearchTree;

interface

uses
  System.Generics.Defaults,
  ods.BinaryTree;

type
  TBSTNode<T> = class (TBTNode)
  public
    x: T;
  end;

  {**
   * A binary search tree class.  The Node parameter should be a subclass
   * of TBSTNode<T>
   *}
  TBinarySearchTree<T; TNode: TBSTNode<T>, constructor> = class(TBinaryTree<TNode>)
  protected
    n: Integer;
    FComparer: IComparer<T>;

    function findLast(x: T): TNode;
    function addChild(p: TNode; u: TNode): Boolean;
    procedure splice(u: TNode);
    procedure removeNode(u: TNode);
    procedure rotateRight(u: TNode);
    procedure rotateLeft(u: TNode);
    function addNode(u: TNode): Boolean;

    function compare(A, B: T): Integer; virtual;
  public
    constructor Create; overload;
    constructor Create(AComparer: IComparer<T>); overload;
    destructor Destroy; override;

    function Add(x: T): Boolean; virtual;
    function Remove(x: T): Boolean; virtual;
    function Find(x: T): T;
    function FindEQ(x: T): T;
    function Size: Integer; override;
    procedure Clear; override;
  end;

implementation

uses
  System.SysUtils;

{ TBinarySearchTree<T, TNode> }

function TBinarySearchTree<T, TNode>.add(x: T): Boolean;
var
  p: TNode;
  u: TNode;
begin
  p := findLast(x);
  u := TNode.Create;
  u.x := x;

  Result := addChild(p, u);
end;

function TBinarySearchTree<T, TNode>.addNode(u: TNode): Boolean;
var
  p: TNode;
begin
  p := findLast(u.x);
  Result := addChild(p, u);
end;

function TBinarySearchTree<T, TNode>.addChild(p, u: TNode): Boolean;
var
  comp: Integer;
begin
  if p = nil then
  begin
    r := u;              // inserting into empty tree
  end
  else
  begin
    comp := compare(u.x, p.x);
    if (comp < 0) then
    begin
      p.left := u;
    end
    else if comp > 0 then
    begin
      p.right := u;
    end
    else
    begin
      Exit(False);   // u.x is already in the tree
    end;
    u.parent := p;
  end;
  Inc(n);
  Result := True;
end;

procedure TBinarySearchTree<T, TNode>.Clear;
begin
  inherited clear();

  n := 0;
end;

function TBinarySearchTree<T, TNode>.compare(A, B: T): Integer;
begin
  Result := FComparer.Compare(A, B);
end;

constructor TBinarySearchTree<T, TNode>.Create(AComparer: IComparer<T>);
begin
  FComparer := AComparer;

  n := 0;
end;

constructor TBinarySearchTree<T, TNode>.Create;
begin
  Create(TComparer<T>.Default);
end;

destructor TBinarySearchTree<T, TNode>.Destroy;
begin

  inherited Destroy;
end;

function TBinarySearchTree<T, TNode>.Find(x: T): T;
var
  w: TNode;
  z: TNode;
  comp: Integer;
begin
  w := r;
  z := nil;

  while w <> nil do
  begin
    comp := compare(x, w.x);
    if comp < 0 then
    begin
      z := w;
      w := TNode(w.left);
    end
    else if comp > 0 then
    begin
      w := TNode(w.right);
    end
    else begin
      Exit(w.x);
    end
  end;

  if z = nil then
    Result := Default(T)
  else
    Result := z.X;
end;

function TBinarySearchTree<T, TNode>.FindEQ(x: T): T;
var
  w: TNode;
  comp: Integer;
begin
  w := r;
  while w <> nil do
  begin
    comp := compare(x, w.x);
    if comp < 0 then
      w := TNode(w.left)
    else if comp > 0 then
      w := TNode(w.right)
    else
      Exit(w.x);
  end;

  Result := Default(T);
end;

function TBinarySearchTree<T, TNode>.findLast(x: T): TNode;
var
  w: TNode;
  prev: TNode;
  comp: Integer;
begin
  w := r;
  prev := nil;

  while w <> nil do
  begin
    prev := w;
    comp := compare(x, w.x);
    if comp < 0 then
      w := TNode(w.left)
    else if comp > 0 then
      w := TNode(w.right)
    else
      Exit(w);
  end;

  Result := prev;
end;

function TBinarySearchTree<T, TNode>.remove(x: T): Boolean;
var
  u: TNode;
begin
  u := findLast(x);
  if (u <> nil) and (compare(x, u.x) = 0) then
  begin
    removeNode(u);
    Exit(True);
  end;
  Result := False;
end;

procedure TBinarySearchTree<T, TNode>.removeNode(u: TNode);
var
  w: TNode;
begin
  if (u.left = nil) or (u.right = nil) then
  begin
    splice(u);
    u.Free;
  end
  else
  begin
    w := TNode(u.right);
    while (w.left <> nil) do
      w := TNode(w.left);
    u.x := w.x;
    splice(w);
    w.Free;
  end;
end;

procedure TBinarySearchTree<T, TNode>.rotateLeft(u: TNode);
var
  w: TNode;
begin
  w := TNode(u.right);
  w.parent := u.parent;
  if w.parent <> nil then
  begin
    if TNode(w.parent.left) = u then
      w.parent.left := w
    else
      w.parent.right := w;
  end;
  u.right := w.left;
  if u.right <> nil then
    u.right.parent := u;

  u.parent := w;
  w.left := u;
  if u = r then
  begin
    r := w;
    r.parent := nil;
  end;
end;

procedure TBinarySearchTree<T, TNode>.rotateRight(u: TNode);
var
  w: TNode;
begin
  w := TNode(u.left);
  w.parent := u.parent;
  if w.parent <> nil then
  begin
    if TNode(w.parent.left) = u then
      w.parent.left := w
    else
      w.parent.right := w;
  end;
  u.left := w.right;
  if u.left <> nil then
    u.left.parent := u;

  u.parent := w;
  w.right := u;
  if u = r then
  begin
    r := w;
    r.parent := nil;
  end;
end;

function TBinarySearchTree<T, TNode>.Size: Integer;
begin
  Result := n;
end;

procedure TBinarySearchTree<T, TNode>.splice(u: TNode);
var
  s, p: TNode;
begin
  if u.left <> nil then
    s := TNode(u.left)
  else
    s := TNode(u.right);

  if u = r then
  begin
    r := s;
    p := nil;
  end
  else
  begin
    p := TNode(u.parent);
    if TNode(p.left) = u then
      p.left := s
    else
      p.right := s;
  end;

  if s <> nil then
    s.parent := p;
  Dec(n);
end;

end.