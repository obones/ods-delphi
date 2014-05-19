unit PerformanceTests;

interface

uses
  System.SysUtils,
  TestFramework,
  ods.BinarySearchTree, ods.RedBlackTree, ods.ScapegoatTree, ods.Treap;


type
  TPerfTimer = class;

  TTreesPerformanceTest = class(TTestCase)
  private
    FPerfTimer: TPerfTimer;

    procedure DoPerf(const AInfo: string; AProc: TProc);
    function GetAddPerfProc<N: TBSTNode<Integer>, constructor; T: TBinarySearchTree<Integer, N>, constructor>(const Elements: TArray<Integer>): TProc;
    function GetFindPerfProc<N: TBSTNode<Integer>, constructor; T: TBinarySearchTree<Integer, N>, constructor>(const Elements: TArray<Integer>): TProc;

    procedure GetElements(var Elements: TArray<Integer>; ElementsCount: Integer);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAdds;
    procedure TestFind;
  end;

  TPerfTimer = class
  private
    FStart: TDateTime;
  public
    procedure Reset;
    function GetDiff: TDateTime;
    function GetFormattedDiff: string;
  end;

implementation

type
  TIntegerBinarySearchTree = TBinarySearchTree<Integer, TBSTNode<Integer>>;
  TIntegerRedBlackTree = TRedBlackTree<Integer, TRedBlackNode<Integer>>;
  TIntegerScapegoatTree = TScapegoatTree<Integer, TScapegoatNode<Integer>>;
  TIntegerTreap = TTreap<Integer, TTreapNode<Integer>>;

{ TTreesPerformanceTest }

procedure TTreesPerformanceTest.DoPerf(const AInfo: string; AProc: TProc);
begin
  FPerfTimer.Reset;
  AProc;
  Status(Format('%s: %s', [AInfo, FPerfTimer.GetFormattedDiff]));
end;

procedure TTreesPerformanceTest.GetElements(var Elements: TArray<Integer>; ElementsCount: Integer);
var
  I: Integer;
begin
  Randomize;
  SetLength(Elements, ElementsCount);
  for I := 0 to ElementsCount - 1 do
    Elements[I] := Random(ElementsCount);
end;

function TTreesPerformanceTest.GetFindPerfProc<N, T>(const Elements: TArray<Integer>): TProc;
begin
  Result :=
    procedure
    const
      LookupCount = 100000;
    var
      I: Integer;
      Tree: T;
    begin
      Tree := T.Create;
      try
        for I := 0 to Length(Elements) - 1 do
          Tree.Add(Elements[I]);

        for I := 0 to LookupCount do
          Tree.Find(I);
      finally
        Tree.Free;
      end;
    end;
end;

function TTreesPerformanceTest.GetAddPerfProc<N, T>(const Elements: TArray<Integer>): TProc;
begin
  Result :=
    procedure
    var
      I: Integer;
      Tree: T;
    begin
      Tree := T.Create;
      try
        for I := 0 to Length(Elements) - 1 do
          Tree.Add(Elements[I]);
      finally
        Tree.Free;
      end;
    end;
end;

procedure TTreesPerformanceTest.SetUp;
begin
  inherited SetUp;

  FPerfTimer := TPerfTimer.Create;
end;

procedure TTreesPerformanceTest.TearDown;
begin
  FPerfTimer.Free;

  inherited TearDown;
end;

procedure TTreesPerformanceTest.TestAdds;
const
  ElementsCount = 1000000;
var
  Elements: TArray<Integer>;
begin
  GetElements(Elements, ElementsCount);

  DoPerf('BinarySearch', GetAddPerfProc<TBSTNode<Integer>, TIntegerBinarySearchTree>(Elements));
  DoPerf('RedBlack', GetAddPerfProc<TRedBlackNode<Integer>, TIntegerRedBlackTree>(Elements));
  DoPerf('ScapeGoat', GetAddPerfProc<TScapegoatNode<Integer>, TIntegerScapegoatTree>(Elements));
  DoPerf('Treap', GetAddPerfProc<TTreapNode<Integer>, TIntegerTreap>(Elements));
end;

procedure TTreesPerformanceTest.TestFind;
const
  ElementsCount = 1000000;
var
  Elements: TArray<Integer>;
begin
  GetElements(Elements, ElementsCount);

  DoPerf('BinarySearch', GetFindPerfProc<TBSTNode<Integer>, TIntegerBinarySearchTree>(Elements));
  DoPerf('RedBlack', GetFindPerfProc<TRedBlackNode<Integer>, TIntegerRedBlackTree>(Elements));
  DoPerf('ScapeGoat', GetFindPerfProc<TScapegoatNode<Integer>, TIntegerScapegoatTree>(Elements));
  DoPerf('Treap', GetFindPerfProc<TTreapNode<Integer>, TIntegerTreap>(Elements));
end;

{ TPerfTimer }

function TPerfTimer.GetDiff: TDateTime;
begin
  Result := Now - FStart;
end;

function TPerfTimer.GetFormattedDiff: string;
begin
  Result := FormatDateTime('nn:ss.zzz', GetDiff);
end;

procedure TPerfTimer.Reset;
begin
  FStart := Now;
end;

end.
