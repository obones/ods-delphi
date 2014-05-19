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
{ The Original Code is ods.BinaryTree.pas.                                                         }
{                                                                                                  }
{ The Initial Developer of the Original Code is Olivier Sannier (obones).                          }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{ Contributors:                                                                                    }
{                                                                                                  }
{**************************************************************************************************}
unit ods.BinaryTree;

interface

type
  TBTNode = class
  public
    left: TBTNode;
    right: TBTNode;
    parent: TBTNode;
  end;

  TBinaryTree<TNode: TBTNode> = class
  protected
    r: TNode;    // root TNode

    function Size(u: TNode): Integer; overload; virtual;
    function Height(u: TNode): Integer; overload; virtual;
    procedure Traverse(u: TNode); overload; virtual;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; virtual;
    function Depth(u: TNode): Integer; virtual;
    function Size: Integer; overload; virtual;
    function Size2: Integer; virtual;
    function Height: Integer; overload; virtual;
    procedure Traverse; overload; virtual;
    procedure Traverse2; virtual;
    procedure BfTraverse; virtual;
  end;

implementation

uses
  System.Math,
  ods.ArrayDeque;

{ TBinaryTree<TNode> }

procedure TBinaryTree<TNode>.BfTraverse;
var
	q: TArrayDeque<TNode>;
  u: TNode;
begin
	if r <> nil then
    q.add(q.size, r);

	while q.size > 0 do
  begin
		u := q.remove(q.size - 1);
		if u.left <> nil then
      q.add(q.size, u.left);
		if u.right <> nil then
      q.add(q.size, u.right);
	end
end;

procedure TBinaryTree<TNode>.Clear;
var
  u: TNode;
  prev: TNode;
  next: TNode;
begin
	u := r;
  prev := nil;

	while u <> nil do
  begin
		if prev = TNode(u.parent) then
    begin
			if u.left <> nil then
        next := TNode(u.left)
			else if u.right <> nil then
         next := TNode(u.right)
			else
        next := TNode(u.parent);
		end
    else if prev = TNode(u.left) then
    begin
			if u.right <> nil then
        next := TNode(u.right)
			else
        next := TNode(u.parent);
		end
    else
    begin
			next := TNode(u.parent);
    end;

		prev := u;
		if next = TNode(u.parent) then
			u.Free;
		u := next;
  end;

	r := nil;
end;

constructor TBinaryTree<TNode>.Create;
begin
	r := nil;
end;

function TBinaryTree<TNode>.Depth(u: TNode): Integer;
begin
	Result := 0;
	while u <> r do
  begin
		u := TNode(u.parent);
		Inc(Result);
	end;
end;

destructor TBinaryTree<TNode>.Destroy;
begin
	Clear;

  inherited Destroy;
end;

function TBinaryTree<TNode>.Height: Integer;
begin
	Result := height(r);
end;

function TBinaryTree<TNode>.Height(u: TNode): Integer;
begin
	if u = nil then
    Result := -1
  else
    Result := 1 + max(height(u.left), height(u.right));
end;

function TBinaryTree<TNode>.Size(u: TNode): Integer;
begin
	if u = nil then
    Result := 0
	else
    Result := 1 + size(u.left) + size(u.right);
end;

function TBinaryTree<TNode>.Size: Integer;
begin
	Result := size(r);
end;

function TBinaryTree<TNode>.Size2: Integer;
var
 u: TNode;
 prev: TNode;
 next: TNode;
begin
  u := r;
  prev := nil;
  Result := 0;

  while u <> nil do
  begin
    if prev = TNode(u.parent) then
    begin
      Inc(Result);
      if u.left <> nil then
        next := TNode(u.left)
      else if u.right <> nil then
        next := TNode(u.right)
      else
        next := TNode(u.parent);
    end
    else if prev = TNode(u.left) then
    begin
      if u.right <> nil then
        next := TNode(u.right)
      else
        next := TNode(u.parent);
    end
    else
    begin
      next := TNode(u.parent);
    end;

    prev := u;
    u := next;
  end;
end;

procedure TBinaryTree<TNode>.Traverse;
begin
	traverse(r);
end;

procedure TBinaryTree<TNode>.Traverse(u: TNode);
begin
  if u = nil then
    Exit;

  traverse(u.left);
  traverse(u.right);
end;

procedure TBinaryTree<TNode>.Traverse2;
var
	u: TNode;
  prev: TNode;
  next: TNode;
begin
	u := r;
  prev := nil;

	while u <> nil do
  begin
		if prev = TNode(u.parent) then
    begin
			if u.left <> nil then
        next := TNode(u.left)
			else if u.right <> nil then
        next := TNode(u.right)
			else
        next := TNode(u.parent);
    end
		else if prev = TNode(u.left) then
    begin
			if u.right <> nil then
        next := TNode(u.right)
			else
        next := TNode(u.parent);
    end
		else
    begin
			next := TNode(u.parent);
		end;

		prev := u;
		u := next;
  end;
end;

end.
