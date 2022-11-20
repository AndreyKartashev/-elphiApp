object fmFormServer: TfmFormServer
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Business Server'
  ClientHeight = 671
  ClientWidth = 944
  Color = clBtnFace
  CustomTitleBar.CaptionAlignment = taCenter
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 700
    Top = 0
    Width = 2
    Height = 671
    ExplicitLeft = 701
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 700
    Height = 671
    Align = alLeft
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'categoryID'
        Title.Alignment = taCenter
        Title.Caption = 'Category ID'
        Width = 83
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'categoryName'
        Title.Alignment = taCenter
        Title.Caption = 'Category Name'
        Width = 141
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'departmentID'
        Title.Alignment = taCenter
        Title.Caption = 'Department ID'
        Width = 88
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'description'
        Title.Alignment = taCenter
        Title.Caption = 'Description'
        Width = 171
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 702
    Top = 0
    Width = 242
    Height = 671
    Align = alClient
    TabOrder = 1
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 240
      Height = 97
      Align = alTop
      TabOrder = 0
      object btnDeploy: TButton
        Left = 40
        Top = 13
        Width = 161
        Height = 33
        Caption = #1044#1077#1087#1083#1086#1081' '#1074' '#1073#1088#1072#1091#1079#1077#1088
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnDeployClick
      end
      object btnAutorisation: TButton
        Left = 40
        Top = 52
        Width = 161
        Height = 33
        Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnAutorisationClick
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 204
      Width = 240
      Height = 134
      Align = alTop
      TabOrder = 1
      object btnCloseApp: TButton
        Left = 40
        Top = 88
        Width = 161
        Height = 33
        Caption = #1047#1072#1082#1088#1099#1090#1100' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnCloseAppClick
      end
      object btnSaveToFIle: TButton
        Left = 40
        Top = 9
        Width = 161
        Height = 33
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083' JSON'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnSaveToFIleClick
      end
      object btnOpenFIle: TButton
        Left = 40
        Top = 48
        Width = 161
        Height = 34
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083' JSON'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = btnOpenFIleClick
      end
    end
    object Panel4: TPanel
      Left = 1
      Top = 338
      Width = 240
      Height = 332
      Align = alClient
      TabOrder = 2
      object Memo1: TMemo
        Left = 1
        Top = 1
        Width = 238
        Height = 330
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object Panel5: TPanel
      Left = 1
      Top = 98
      Width = 240
      Height = 106
      Align = alTop
      TabOrder = 3
      object btnInsertRecords: TButton
        Left = 40
        Top = 14
        Width = 161
        Height = 40
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' 5000 '#1079#1072#1087#1080#1089#1077#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnInsertRecordsClick
      end
      object btnSsaveUpdates: TButton
        Left = 40
        Top = 60
        Width = 161
        Height = 33
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Persist Security Info=False;User ID=sa;Initi' +
      'al Catalog=SportGoods;Data Source=KARTASHEV'
    Provider = 'SQLOLEDB.1'
    Left = 504
    Top = 176
  end
  object ADOTable1: TADOTable
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'Category'
    Left = 504
    Top = 240
  end
  object DataSource1: TDataSource
    DataSet = ADOTable1
    Left = 504
    Top = 296
  end
  object RESTClient1: TRESTClient
    Authenticator = OAuth2Authenticator1
    BaseURL = 'https://localhost:8080'
    Params = <>
    Left = 400
    Top = 176
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    Left = 400
    Top = 240
  end
  object RESTResponse1: TRESTResponse
    Left = 400
    Top = 296
  end
  object OpenDialog1: TOpenDialog
    FileName = 'PrimerTest.json'
    Filter = '*.json|*.JSON'
    Left = 296
    Top = 240
  end
  object OAuth2Authenticator1: TOAuth2Authenticator
    AccessTokenEndpoint = 'https://accounts.google.com/o/oauth2/token'
    AuthorizationEndpoint = 'https://accounts.google.com/o/oauth2/auth'
    RedirectionEndpoint = 'urn:ietf:wg:oauth:2.0:oob'
    Scope = 'https://www.googleapis.com/auth/drive'
    Left = 400
    Top = 360
  end
  object SaveDialog1: TSaveDialog
    FileName = 'D:\Delphi\primer.json'
    Filter = 'JSON|*.json'
    Left = 296
    Top = 176
  end
end
