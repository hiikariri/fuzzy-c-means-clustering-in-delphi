object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 447
  ClientWidth = 1114
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 14
    Width = 223
    Height = 28
    Caption = 'Fuzzy C-means Clustering'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object StringGridData: TStringGrid
    Left = 151
    Top = 64
    Width = 138
    Height = 360
    ColCount = 2
    FixedCols = 0
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goFixedRowDefAlign]
    TabOrder = 0
  end
  object StringGridMembership: TStringGrid
    Left = 303
    Top = 64
    Width = 794
    Height = 79
    FixedCols = 0
    RowCount = 3
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goFixedRowDefAlign]
    TabOrder = 1
    ColWidths = (
      64
      64
      64
      64
      64)
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 48
    Width = 129
    Height = 376
    Caption = 'GroupBox1'
    TabOrder = 2
    object Button1: TButton
      Left = 16
      Top = 24
      Width = 97
      Height = 33
      Caption = 'Process'
      TabOrder = 0
      OnClick = BtnRunClick
    end
    object LabeledEdit1: TLabeledEdit
      Left = 16
      Top = 80
      Width = 97
      Height = 23
      EditLabel.Width = 70
      EditLabel.Height = 15
      EditLabel.Caption = 'Exponent (Q)'
      TabOrder = 1
      Text = '2'
    end
    object LabeledEdit2: TLabeledEdit
      Left = 16
      Top = 129
      Width = 97
      Height = 23
      EditLabel.Width = 96
      EditLabel.Height = 15
      EditLabel.Caption = 'Tolerance Level ('#949')'
      TabOrder = 2
      Text = '0.01'
    end
    object Button2: TButton
      Left = 16
      Top = 158
      Width = 97
      Height = 33
      Caption = 'Add Point'
      TabOrder = 3
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 16
      Top = 197
      Width = 97
      Height = 33
      Caption = 'Remove Point'
      TabOrder = 4
      OnClick = Button3Click
    end
    object BitBtn1: TBitBtn
      Left = 16
      Top = 316
      Width = 97
      Height = 45
      Kind = bkClose
      NumGlyphs = 2
      TabOrder = 5
    end
    object BitBtn2: TBitBtn
      Left = 16
      Top = 277
      Width = 97
      Height = 33
      Caption = 'Reset'
      TabOrder = 6
      OnClick = BitBtn2Click
    end
  end
  object Chart1: TChart
    Left = 303
    Top = 160
    Width = 489
    Height = 264
    Legend.Alignment = laTop
    Legend.CheckBoxes = True
    Title.Text.Strings = (
      'Cluster')
    BottomAxis.ExactDateTime = False
    BottomAxis.Increment = 0.500000000000000000
    BottomAxis.LabelsSeparation = 0
    View3D = False
    TabOrder = 3
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series1: TPointSeries
      HoverElement = [heCurrent]
      ClickableLine = False
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series2: TPointSeries
      HoverElement = [heCurrent]
      ClickableLine = False
      Pointer.Brush.Color = clRed
      Pointer.InflateMargins = True
      Pointer.Style = psCircle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object ListBox1: TListBox
    Left = 798
    Top = 160
    Width = 299
    Height = 264
    ItemHeight = 15
    TabOrder = 4
  end
end
