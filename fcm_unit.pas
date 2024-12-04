unit fcm_unit;

interface

uses
  System.SysUtils, Vcl.Forms, Vcl.Grids, Vcl.StdCtrls, Vcl.ExtCtrls, VclTee.TeeProcs, VclTee.Chart, VclTee.Series,
  System.Classes, Vcl.Controls, VclTee.TeeGDIPlus, VCLTee.TeEngine, Math,
  Vcl.Mask, Vcl.Buttons;

type
  TPointF = record
    X: Extended;
    Y: Extended;
  end;

  TDoubleMatrix = array of array of Extended;
type
  TForm3 = class(TForm)
    StringGridData: TStringGrid;
    StringGridMembership: TStringGrid;
    Button1: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Chart1: TChart;
    Series1: TPointSeries;
    ListBox1: TListBox;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    Button2: TButton;
    Button3: TButton;
    Series2: TPointSeries;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BtnRunClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    procedure AddMembershipColumn;
    procedure InitializeData;
    procedure UpdateClusterCenter(var ClusterCenter: array of TPointF; Membership: TDoubleMatrix);
    procedure UpdateMembership(var Membership: TDoubleMatrix; ClusterCenter: array of TPointF);
    function Convergence(MembershipOld, MembershipNew: TDoubleMatrix): Boolean;
  public
  end;

var
  Form3: TForm3;
  epsilon, Q: Extended;

implementation

{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
begin
  InitializeData;
  Button1.OnClick := BtnRunClick;
end;

procedure TForm3.AddMembershipColumn;
begin
  StringGridMembership.ColCount := StringGridMembership.ColCount + 1;
  StringGridMembership.Cells[StringGridMembership.ColCount - 1, 0] := Format('Point %d', [StringGridMembership.ColCount - 1]);
  StringGridMembership.Cells[StringGridMembership.ColCount - 1, 1] := '0.0'; // Default membership value
  StringGridMembership.Cells[StringGridMembership.ColCount - 1, 2] := '0.0'; // Default membership value
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  StringGridData.RowCount := StringGridData.RowCount + 1;
  StringGridData.Cells[0, StringGridData.RowCount - 1] := '0.0'; // Default value
  StringGridData.Cells[1, StringGridData.RowCount - 1] := '0.0'; // Default value
  AddMembershipColumn;
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
  if StringGridData.RowCount > 2 then
  begin
    StringGridData.RowCount := StringGridData.RowCount - 1;
    StringGridMembership.ColCount := StringGridMembership.ColCount - 1;
  end;
end;

procedure TForm3.InitializeData;
begin
  // Setup data grid for points
  StringGridData.RowCount := 5;  // 4 data points + header
  StringGridData.ColCount := 2; // x, y columns
  StringGridData.Cells[0, 0] := 'x';
  StringGridData.Cells[1, 0] := 'y';

  // Data points
  StringGridData.Cells[0, 1] := '1.0'; StringGridData.Cells[1, 1] := '3.0';
  StringGridData.Cells[0, 2] := '1.5'; StringGridData.Cells[1, 2] := '3.2';
  StringGridData.Cells[0, 3] := '1.3'; StringGridData.Cells[1, 3] := '2.8';
  StringGridData.Cells[0, 4] := '3.0'; StringGridData.Cells[1, 4] := '1.0';

  // Initial membership matrix
  StringGridMembership.RowCount := 3; // 2 clusters + header
  StringGridMembership.ColCount := 5; // 4 data points + header
  StringGridMembership.Cells[0, 0] := 'Cluster';
  StringGridMembership.Cells[1, 0] := 'Point 1';
  StringGridMembership.Cells[2, 0] := 'Point 2';
  StringGridMembership.Cells[3, 0] := 'Point 3';
  StringGridMembership.Cells[4, 0] := 'Point 4';
  StringGridMembership.Cells[0, 1] := 'C1';
  StringGridMembership.Cells[0, 2] := 'C2';

  // Membership values (initial U^(0))
  StringGridMembership.Cells[1, 1] := '1.0'; StringGridMembership.Cells[1, 2] := '0.0';
  StringGridMembership.Cells[2, 1] := '1.0'; StringGridMembership.Cells[2, 2] := '0.0';
  StringGridMembership.Cells[3, 1] := '1.0'; StringGridMembership.Cells[3, 2] := '0.0';
  StringGridMembership.Cells[4, 1] := '0.0'; StringGridMembership.Cells[4, 2] := '1.0';
end;

// Vij
procedure TForm3.UpdateClusterCenter(var ClusterCenter: array of TPointF; Membership: TDoubleMatrix);
var
  i, j: Integer;
  NumX, NumY, Denom: Extended;
begin
  for i := 0 to High(ClusterCenter) do
  begin
    NumX := 0; NumY := 0; Denom := 0;
    for j := 0 to StringGridData.RowCount - 2 do
    begin
      NumX := NumX + Power(Membership[i][j], Q) * StrToFloat(StringGridData.Cells[0, j + 1]);
      NumY := NumY + Power(Membership[i][j], Q) * StrToFloat(StringGridData.Cells[1, j + 1]);
      Denom := Denom + Power(Membership[i][j], Q);
    end;
    ClusterCenter[i].X := NumX / Denom;
    ClusterCenter[i].Y := NumY / Denom;
  end;
end;

// U
procedure TForm3.UpdateMembership(var Membership: TDoubleMatrix; ClusterCenter: array of TPointF);
var
  i, j, k: Integer;
  d, sum, eps: Extended;
begin
  eps := 1E-10; // Avoid division by zero
  for i := 0 to StringGridData.RowCount - 2 do
  begin
    for j := 0 to High(ClusterCenter) do
    begin
      d := Sqrt(Sqr(StrToFloat(StringGridData.Cells[0, i + 1]) - ClusterCenter[j].X) +
                   Sqr(StrToFloat(StringGridData.Cells[1, i + 1]) - ClusterCenter[j].Y)) + eps;
      sum := 0;
      for k := 0 to High(ClusterCenter) do
        sum := sum + Power(d / (Sqrt(Sqr(StrToFloat(StringGridData.Cells[0, i + 1]) - ClusterCenter[k].X) +
                                       Sqr(StrToFloat(StringGridData.Cells[1, i + 1]) - ClusterCenter[k].Y)) + eps), 2 / (Q - 1));
      Membership[j][i] := 1 / sum;
    end;
  end;
end;

function TForm3.Convergence(MembershipOld, MembershipNew: TDoubleMatrix): Boolean;
var
  i, j: Integer;
  error: Extended;
begin
  error := 0;
  for i := 0 to High(MembershipOld) do
    for j := 0 to High(MembershipOld[i]) do
      error := error + Abs(MembershipNew[i][j] - MembershipOld[i][j]);

  Result := error < epsilon;
end;

procedure TForm3.BitBtn2Click(Sender: TObject);
begin
  Series1.Clear;
  Series2.Clear;
  ListBox1.Clear;
  InitializeData;
end;

procedure TForm3.BtnRunClick(Sender: TObject);
var
  ClusterCenter: array of TPointF;
  MembershipOld, MembershipNew: TDoubleMatrix;
  Iterations, i, j: Integer;
  IterationInfo: string;
begin
  SetLength(ClusterCenter, 2); // 2 clusters
  SetLength(MembershipOld, 2, StringGridData.RowCount - 1);
  SetLength(MembershipNew, 2, StringGridData.RowCount - 1);

  Q := StrToFloat(LabeledEdit1.Text);
  epsilon := StrToFloat(LabeledEdit2.Text);

  ListBox1.Clear;
  Series1.Clear;
  Series2.Clear;

  // Copy initial membership matrix from StringGrid
  for i := 0 to 1 do
    for j := 0 to StringGridData.RowCount - 2 do
      MembershipOld[i][j] := StrToFloat(StringGridMembership.Cells[j + 1, i + 1]);

  Iterations := 0;
  repeat
    Inc(Iterations);

    // Update ClusterCenter based on the old membership matrix
    UpdateClusterCenter(ClusterCenter, MembershipOld);

    // Update the membership matrix
    UpdateMembership(MembershipNew, ClusterCenter);

    // Log the current membership matrix to the ListBox
    ListBox1.Items.Add(Format('Iteration %d:', [Iterations]));

    // Log the membership matrix
    for i := 0 to High(MembershipNew) do
    begin
      IterationInfo := Format('C%d Memberships: ', [i + 1]);
      for j := 0 to High(MembershipNew[i]) do
        IterationInfo := IterationInfo + Format('%.4f ', [MembershipNew[i][j]]);
        ListBox1.Items.Add(IterationInfo);
    end;

    // Log the cluster center points
    ListBox1.Items.Add('Cluster Center Points:');
    for i := 0 to High(ClusterCenter) do
      ListBox1.Items.Add(Format('V%d: (%.4f, %.4f)', [i + 1, ClusterCenter[i].X, ClusterCenter[i].Y]));
    ListBox1.Items.Add('');

    // Check convergence
    if Convergence(MembershipOld, MembershipNew) then Break;

    // Copy new to old membership matrix
    for i := 0 to High(MembershipOld) do
      for j := 0 to High(MembershipOld[i]) do
        MembershipOld[i][j] := MembershipNew[i][j];
  until Iterations > 100;  // Limit the iteration to prevent stuck looping

  // Display final cluster center points on Chart1
  for i := 0 to StringGridData.RowCount - 2 do
    Series1.AddXY(StrToFloat(StringGridData.Cells[0, i + 1]), StrToFloat(StringGridData.Cells[1, i + 1]));
  for i := 0 to High(ClusterCenter) do
    Series2.AddXY(ClusterCenter[i].X, ClusterCenter[i].Y);
end;

end.

