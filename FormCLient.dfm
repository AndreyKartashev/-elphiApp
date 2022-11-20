object fmFormClient: TfmFormClient
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Business CLient'
  ClientHeight = 610
  ClientWidth = 944
  Color = clBtnFace
  CustomTitleBar.CaptionAlignment = taCenter
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 944
    Height = 610
    Align = alClient
    TabOrder = 0
    object Bevel1: TBevel
      Left = 6
      Top = 5
      Width = 254
      Height = 603
    end
    object Label1: TLabel
      Left = 36
      Top = 17
      Width = 193
      Height = 19
      Caption = #1055#1086#1080#1089#1082' '#1076#1072#1085#1085#1099#1093' '#1085#1072' '#1089#1077#1088#1074#1077#1088#1077':'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 36
      Top = 45
      Width = 72
      Height = 16
      Caption = 'Category ID:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 36
      Top = 93
      Width = 93
      Height = 16
      Caption = 'Category Name:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 80
      Top = 200
      Width = 102
      Height = 19
      Caption = #1051#1086#1075#1080#1088#1086#1074#1072#1085#1080#1077':'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btnSend: TButton
      Left = 32
      Top = 151
      Width = 177
      Height = 35
      Caption = #1047#1072#1087#1088#1086#1089' '#1076#1072#1085#1085#1099#1093' '#1085#1072' '#1089#1077#1088#1074#1077#1088
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnSendClick
    end
    object btnSaveToFIle: TButton
      Left = 22
      Top = 566
      Width = 110
      Height = 35
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnSaveToFIleClick
    end
    object edID: TEdit
      Left = 32
      Top = 64
      Width = 177
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = '1'
    end
    object memData: TMemo
      Left = 8
      Top = 225
      Width = 252
      Height = 192
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 3
      OnClick = memDataClick
    end
    object edName: TEdit
      Left = 32
      Top = 112
      Width = 177
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Text = 'Category15'
    end
    object btnGrid: TButton
      Left = 69
      Top = 423
      Width = 105
      Height = 35
      Caption = #1042' '#1090#1072#1073#1083#1080#1094#1091' (Grid)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = memDataClick
    end
    object RadioGroup1: TRadioGroup
      Left = 13
      Top = 464
      Width = 247
      Height = 96
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemIndex = 1
      Items.Strings = (
        '"'#1053#1072' '#1083#1077#1090#1091'" - '#1087#1086#1089#1083#1077' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1079#1072#1087#1088#1086#1089#1072
        #1050#1072#1078#1076#1099#1081' '#1079#1072#1087#1088#1086#1089' '#1074' '#1086#1090#1076#1077#1083#1100#1085#1099#1081' '#1092#1072#1081#1083
        #1042#1089#1077' '#1079#1072#1087#1088#1086#1089#1099' '#1074' '#1086#1076#1080#1085' '#1092#1072#1081#1083)
      ParentFont = False
      TabOrder = 6
    end
    object Panel2: TPanel
      Left = 266
      Top = 1
      Width = 677
      Height = 608
      Align = alRight
      TabOrder = 7
      object StringGridData: TStringGrid
        Left = 1
        Top = 1
        Width = 675
        Height = 415
        Align = alClient
        DefaultColWidth = 120
        FixedColor = clPurple
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        RowHeights = (
          24
          24
          24
          24
          24)
      end
      object Memo1: TMemo
        Left = 1
        Top = 416
        Width = 675
        Height = 191
        Align = alBottom
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
    object btnOpenFromFile: TButton
      Left = 138
      Top = 566
      Width = 110
      Height = 35
      Caption = #1054#1090#1082#1088#1099#1090#1100
      TabOrder = 8
      OnClick = btnOpenFromFileClick
    end
    object Button2: TButton
      Left = 734
      Top = 490
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 9
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 822
      Top = 490
      Width = 75
      Height = 25
      Caption = 'Stop'
      TabOrder = 10
      OnClick = Button3Click
    end
    object edData: TEdit
      Left = 734
      Top = 460
      Width = 163
      Height = 24
      TabOrder = 11
    end
  end
  object SaveDialog1: TSaveDialog
    FileName = 'TestPrimer.json'
    Filter = 'json|*.json|txt|*.txt'
    Left = 296
    Top = 512
  end
  object OpenDialog1: TOpenDialog
    Left = 352
    Top = 512
  end
end
