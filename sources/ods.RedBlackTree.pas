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
{ The Original Code is ods.RedBlackTree.pas.                                                       }
{                                                                                                  }
{ The Initial Developer of the Original Code is Olivier Sannier (obones).                          }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{ Contributors:                                                                                    }
{                                                                                                  }
{**************************************************************************************************}
unit ods.RedBlackTree;

interface

uses
  ods.BinarySearchTree;

type
  TRedBlackNode<T> = class(TBSTNode<T>)
  protected
    colour: Byte;
  end;

  TRedBlackTree<T; TNode: TRedBlackNode<T>, constructor> = class(TBinarySearchTree<T, TNode>)
  protected
    const red: Byte = 0;
    const black: Byte = 1;

    procedure pushBlack(u: TNode);
    procedure pullBlack(u: TNode);
    procedure flipLeft(u: TNode);
    procedure flipRight(u: TNode);
    procedure swapcolours(u: TNode; w: TNode);
    procedure addFixup(u: TNode);
    procedure removeFixup(u: TNode);
    function removeFixupCase1(u: TNode): TNode;
    function removeFixupCase2(u: TNode): TNode;
    function removeFixupCase3(u: TNode): TNode;
    procedure verify; overload;
    function verify(u: TNode): Integer; overload;
  public
    constructor Create;

    function Add(x: T): Boolean; override;
    function Remove(x: T): Boolean; override;
  end;

implementation

{ TRedBlackTree<T, TNode> }

function TRedBlackTree<T, TNode>.Add(x: T): Boolean;
var
  u: TNode;
begin
  u := TNode.Create;
  u.left := nil;
  u.right := nil;
  u.parent := nil;
  u.x := x;
  u.colour := red;
  Result := inherited addNode(u);
  if Result then
    addFixup(u);
end;

procedure TRedBlackTree<T, TNode>.addFixup(u: TNode);
var
  w: TNode;
  g: TNode;
begin
  while u.colour = red do
  begin
    if u = r then
    begin // u is the root - done
      u.colour := black;
      Exit;
    end;

    w := TNode(u.parent);
    if TNode(w.left).colour = black then
    begin // ensure left-leaning
      flipLeft(w);
      u := w;
      w := TNode(u.parent);
    end;
    if w.colour = black then
      Exit; // no red-red edge := done
    g := TNode(w.parent); // grandparent of u
    if TNode(g.right).colour = black then
    begin
      flipRight(g);
      Exit;
    end
    else
    begin
      pushBlack(g);
      u := g;
    end
  end
end;

constructor TRedBlackTree<T, TNode>.Create;
begin
  inherited Create;
end;

procedure TRedBlackTree<T, TNode>.flipLeft(u: TNode);
begin
  swapcolours(u, TNode(u.right));
  rotateLeft(u);
end;

procedure TRedBlackTree<T, TNode>.flipRight(u: TNode);
begin
  swapcolours(u, TNode(u.left));
  rotateRight(u);
end;

procedure TRedBlackTree<T, TNode>.pullBlack(u: TNode);
begin
  Inc(u.colour);
  Dec(TNode(u.left).colour);
  Dec(TNode(u.right).colour);
end;

procedure TRedBlackTree<T, TNode>.pushBlack(u: TNode);
begin
  Dec(u.colour);
  Inc(TNode(u.left).colour);
  Inc(TNode(u.right).colour);
end;

function TRedBlackTree<T, TNode>.Remove(x: T): Boolean;
var
  u: TNode;
  w: TNode;
begin
  u := findLast(x);
  if (u = nil) or (compare(u.x, x) <> 0) then
    Exit(false);
  w := TNode(u.right);
  if w = nil then
  begin
    w := u;
    u := TNode(w.left);
  end
  else
  begin
    while (w.left <> nil) do
      w := TNode(w.left);
    u.x := w.x;
    u := TNode(w.right);
  end;
  splice(w);
  u.colour := u.colour + w.colour;
  u.parent := TNode(w.parent);
  w.Free;
  removeFixup(u);
  Exit(true);
end;

procedure TRedBlackTree<T, TNode>.removeFixup(u: TNode);
var
  w: TNode;
begin
  while u.colour > black do
  begin
    if u = r then
      u.colour := black
    else if TNode(u.parent.left).colour = red then
      u := removeFixupCase1(u)
    else if u = TNode(u.parent.left) then
      u := removeFixupCase2(u)
    else
      u := removeFixupCase3(u);
  end;
  if u <> r then
  begin // restore left-leaning property, if needed
    w := TNode(u.parent);
    if (TNode(w.right).colour = red) and (TNode(w.left).colour = black) then
      flipLeft(w);
  end;
end;

function TRedBlackTree<T, TNode>.removeFixupCase1(u: TNode): TNode;
begin
  flipRight(TNode(u.parent));
  Exit(u);
end;

function TRedBlackTree<T, TNode>.removeFixupCase2(u: TNode): TNode;
var
  w: TNode;
  v: TNode;
  q: TNode;
begin
  w := TNode(u.parent);
  v := TNode(w.right);
  pullBlack(w); // w.left
  flipLeft(w); // w is now red
  q := TNode(w.right);
  if (q.colour = red) then
  begin // q-w is red-red
    rotateLeft(w);
    flipRight(v);
    pushBlack(q);
    if TNode(v.right).colour = red then
      flipLeft(v);
    Result := q;
  end
  else
  begin
    Result := v;
  end
end;

function TRedBlackTree<T, TNode>.removeFixupCase3(u: TNode): TNode;
var
  w: TNode;
  v: TNode;
  q: TNode;
begin
  w := TNode(u.parent);
  v := TNode(w.left);
  pullBlack(w);
  flipRight(w);            // w is now red
  q := TNode(w.left);
  if q.colour = red then
  begin // q-w is red-red
    rotateRight(w);
    flipLeft(v);
    pushBlack(q);
    Result := q;
  end
  else
  begin
    if TNode(v.left).colour = red then
    begin
      pushBlack(v); // both v's children are red
      Result := v;
    end
    else
    begin // ensure left-leaning
      flipLeft(v);
      Result := w;
    end
  end
end;

procedure TRedBlackTree<T, TNode>.swapcolours(u, w: TNode);
var
  tmp: Byte;
begin
  tmp := u.colour;
  u.colour := w.colour;
  w.colour := tmp;
end;

function TRedBlackTree<T, TNode>.verify(u: TNode): Integer;
var
  dl: Integer;
  dr: Integer;
begin
  if (u = nil) then
    Exit(black);
  assert((u.colour = red) or (u.colour = black));
  if (u.colour = red) then
    Assert((TNode(u.left).colour = black) and (TNode(u.right).colour = black));
  Assert((TNode(u.right).colour = black) or (TNode(u.left).colour = red));
  dl := verify(TNode(u.left));
  dr := verify(TNode(u.right));
  if (dl <> dr) then
    Result := dl + u.colour;
end;

procedure TRedBlackTree<T, TNode>.verify;
begin
  assert (NodeSize(r) = n);
  verify(r);
end;

end.