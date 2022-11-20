{ ������ - ��������� ����������, �������� ������ �������, 20 ������ 2022 ����.
  �������� ������� � �������� "��� ������ �������".

  ����� �������: fmFormServer.

  ������ ������� - � unite Threads.pas.
  ������ - FormServer.pas.
  ������ - FormClient.pas.
}


unit FormServer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls, REST.Types, System.JSON, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Authenticator.OAuth.WebForm.Win, System.StrUtils, System.Types,
  REST.Authenticator.OAuth;

type
  TfmFormServer = class(TForm)
    DBGrid1: TDBGrid;
    ADOConnection1: TADOConnection;
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    btnDeploy: TButton;
    Panel1: TPanel;
    btnAutorisation: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    btnSsaveUpdates: TButton;
    btnCloseApp: TButton;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    OpenDialog1: TOpenDialog;
    OAuth2Authenticator1: TOAuth2Authenticator;
    Panel4: TPanel;
    btnSaveToFile: TButton;
    Memo1: TMemo;
    SaveDialog1: TSaveDialog;
    btnInsertRecords: TButton;
    Panel5: TPanel;
    btnOpenFIle: TButton;
    Splitter1: TSplitter;

    procedure btnCloseAppClick(Sender: TObject);
    procedure btnSaveUpdatesClick(Sender: TObject);

    procedure btnDeployClick(Sender: TObject);

    procedure UploadFile(FileName: String);
    procedure TitleChanged(const ATitle: string;  var DoCloseWebView: boolean);
    procedure AfterRedirect(const AURL: string; var DoCloseWebView : boolean);

    procedure btnAutorisationClick(Sender: TObject);
    procedure btnSaveToFileClick(Sender: TObject);
    procedure SendText(str: String);

    procedure InsertRecords(ID, MaxCount: Integer);
    procedure btnInsertRecordsClick(Sender: TObject);
    procedure btnOpenFIleClick(Sender: TObject);
    procedure TableSearch(Rstr: String);

   type
      RecParams = record
        ID, Name, Department, Description : String;
      end;

  private
    { Private declarations }
    procedure ReceiveData(var MessageData: TWMCopyData); message WM_COPYDATA;


  public
    { Public declarations }
  end;

const
  CMD_SETLABELTEXT = 1; //������ ID �������
  MaxCountInserted = 5000;

var
  fmFormServer: TfmFormServer;

implementation

{$R *.dfm}

procedure TfmFormServer.ReceiveData(var MessageData: TWMCopyData);
var
  ReceivedStr : String;

begin
  //������������� �������� �����, ���� �������� ������� ���������
  if MessageData.CopyDataStruct.dwData = CMD_SETLABELTEXT then
  begin
    ReceivedStr := PAnsiChar(MessageData.CopyDataStruct.lpData);

  //������������� ����� �� ���������� ������
    Memo1.Lines.Add(ReceivedStr);

  // ����� ������ � �������� ������ �� �� �� ������ ���������
    TableSearch(ReceivedStr);

    MessageData.Result := 1;
  end
  else
    MessageData.Result := 0;
end;

procedure TfmFormServer.TableSearch(Rstr: String);
var
    Rec1: RecParams;
    // ������ �������
    PHaveRecord : boolean;
begin

  with AdoTable1 do
  begin
      DisableControls;

      PHaveRecord := false;
      First;
      var i:=1;

      while ((i <= RecordCount) and (PHaveRecord = false)) do
      begin
        Application.ProcessMessages;
        if (IntToStr(FieldByName('categoryID').Value) = RStr) or
        (FieldByName('categoryName').Value = RStr)

        then

        begin
            PHaveRecord:= true;


            Rec1.ID := IntToStr(FieldByName('categoryID').Value);
            Rec1.Name := FieldByName('categoryName').Value;
            Rec1.Department := IntToStr(FieldByName('departmentID').Value);
            Rec1.Description := FieldByName('description').Value;

            SendText(Rec1.ID);
            SendText(Rec1.Name);
            SendText(Rec1.Department);
            SendText(Rec1.Description);

            First;
        end

        else

        begin
            PHaveRecord := false;
            i:=i+1;

            Next;
        end;
      end;

     First;
     EnableControls;

    {  if (PHaveRecord = true) then
        ShowMessage('������ � ���� ������ �������, ID = ' + Rec1.ID)
      else
        ShowMessage('������ � ������ ����������� �� �������.');
    }

  end;

end;

procedure TfmFormServer.SendText(str: String);
var
  CDS: TCopyDataStruct;
begin
  //������������� ��� �������
  CDS.dwData := CMD_SETLABELTEXT;
  //������������� ����� ������������ ������
  CDS.cbData := Length(str) + 1;
  //�������� ������ ������ ��� �������� ������
  GetMem(CDS.lpData, CDS.cbData);
  try
    //�������� ������ � �����
    StrPCopy(CDS.lpData, AnsiString(str));
    //�������� ��������� � ���� � ���������� StringReceiver
    SendMessage(FindWindow(nil,'Business Client'),
                  WM_COPYDATA, Handle, Integer(@CDS));
  finally
    //������������ �����
    FreeMem(CDS.lpData, CDS.cbData);
  end;
end;


procedure  TfmFormServer.InsertRecords(ID, MaxCount: Integer);
var i: Integer;
begin
  with ADOTable1 do
  begin
    First;
    DisableControls;
    for i:=1 to MaxCount do
    begin
      Insert;
      FieldByName('categoryID').Value := i;
      FieldByName('categoryName').Value := 'Category'+IntToStr(i);
      FieldByName('departmentID').Value := i*10+i;
      FieldByName('description').Value := '����� ' + IntToStr(i);
      Next;
    end;
    ADOTable1.UpdateBatch(arAll);
    EnableControls;
  end;
end;

procedure TfmFormServer.AfterRedirect(const AURL: string; var DoCloseWebView: boolean);
begin
  Memo1.Lines.Add('after redirect to ' + AURL);
end;

procedure TfmFormServer.TitleChanged(const ATitle: string;
  var DoCloseWebView: boolean);
begin
  Memo1.Lines.Add('== '+ATitle);
end;


procedure TfmFormServer.btnDeployClick(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    UploadFile(OpenDialog1.FileName);
  end;

end;


procedure TfmFormServer.UploadFile(FileName: String);
var SFileName,Link,Mem:String;
    Code:Integer;

begin
  //�������� ������ ��� �����, ��� �����
  SFileName:=ExtractFileName(FileName);
  Memo1.Lines.Add('Uploading ' + SFileName);

  //�������������� ���������
  RESTRequest1.Params.Clear;
  RESTRequest1.Params.Add;

  //� ������ ������� �������������� ��������� � ������
  //� �������, ����� ����� 401 UNAUTHORIZED

  RESTRequest1.Params[0].Kind:=TRESTRequestParameterKind.pkHTTPHEADER;
  RESTRequest1.Params[0].name:='Authorization';
  RESTRequest1.Params[0].Options:=[poDoNotEncode];
  RESTRequest1.Params[0].Value:='OAuth ' + OAuth2Authenticator1.AccessToken;

  //����� - ���� ��������
  //������ ������ � ����� ����������

  RESTRequest1.Params.Add;
  RESTRequest1.Params[0].name:='path';
  RESTRequest1.Params[0].Value:='app:/'+SFilename;

  //����������� ��� ��������
  RESTRequest1.Params.Add;
  RESTRequest1.Params[1].name:='overwrite';
  RESTRequest1.Params[1].Value:='true';

  RESTRequest1.Resource:='/disk/resources/upload';
  RESTRequest1.Method:=rmGet;

  //�� � ���������� ������ ������ �� ��������
  RESTRequest1.Execute;

  if RESTRequest1.Response.StatusCode=200 then begin
    //��� ���������, ��� ������� ������� ���������� JSON
    Memo1.Lines.Add(RESTRequest1.Response.Content);

    //�������� ������ �� ��������
    Link:=TJSONObject(RESTRequest1.Response.JSONValue).GetValue('href').Value;

    Memo1.lines.add(Link);   //���������� ������� ����

    Mem:=RESTClient1.BaseURL;

    try      //����������� ������ �� ��������
      RESTClient1.BaseURL:=Link;
      //������� ���������, ����� ��� ��� �� �����       RESTRequest1.Params.Clear;
      RESTRequest1.Resource:='';
      //��������� ���� � ������
      RESTRequest1.AddFile(FileName);

      //����� - PUT
      RESTRequest1.Method:=rmPUT;      //�� � ���������� ���� �� ������
      RESTRequest1.Execute;

    finally
      //����� ���� ��������������� ������ �� API
      RESTClient1.BaseURL:=Mem;
    end;

    Code:=RESTRequest1.Response.StatusCode;
    if Code=201 then Memo1.Lines.Add('���� ������� ��������');
    if Code=202 then Memo1.Lines.Add('���� �������� �� ������, �� ���� �� ������� � ����� ����������');
    if Code=412 then Memo1.Lines.Add('��� ���������� ����� ��� ������� �������� �������� � ��������� Content-Range');
    if Code=413 then Memo1.Lines.Add('������ ����� ��������� 10��');
    if Code=500 then Memo1.Lines.Add('���������� ������ �������, ���������� �����');
    if Code=503 then Memo1.Lines.Add('������ ����������, ���������� �����');
    if Code=507 then Memo1.Lines.Add('��������� ����� �� �����');

  end else Memo1.Lines.Add('������ ������ - ������ '+RESTRequest1.Response.StatusCode.ToString);
end;

{
Authorization-Endpoint: https://accounts.google.com/o/oauth2/auth
Token-Endpoint: https://accounts.google.com/o/oauth2/token
Redirctioon-Endpoint: urn:ietf:wg:oauth:2.0:oob
Client-ID: �������� Client ID ������ �������
Client-Secret: �������� Client Secret ������ �������
Access-Scope: https://www.googleapis.com/auth/drive

}

procedure TfmFormServer.btnAutorisationClick(Sender: TObject);
var wf: Tfrm_OAuthWebForm;
begin
  //������� ���� � ���������
  //��� ��������������� ������������ �� �������� Google
  wf:=Tfrm_OAuthWebForm.Create(self);
  try
    //���������� ���������� ������� ����� Title
    wf.OnTitleChanged:=TitleChanged;
    wf.OnAfterRedirect:=AfterRedirect;
    //���������� ���� � ���������
    //� �������� URL � ������ ������������� �������
    wf.ShowModalWithURL(OAuth2Authenticator1.AuthorizationRequestURI);
  finally
    FreeAndNil(wf);
  end;
end;

procedure TfmFormServer.btnSaveUpdatesClick(Sender: TObject);
begin
    AdoTable1.Edit;
    AdoTable1.UpdateBatch;
end;

procedure TfmFormServer.btnCloseAppClick(Sender: TObject);
begin
    AdoTable1.Edit;
    AdoTable1.UpdateBatch;
    Application.Terminate;
end;


procedure TfmFormServer.btnInsertRecordsClick(Sender: TObject);
begin
   InsertRecords(5, MaxCountInserted);
end;

//  �������� � JSON � ������� (�� �����).
procedure TfmFormServer.btnSaveToFileClick(Sender: TObject);
var
  JSON: TJSONObject;
  CategoryName : String;
  PName, PValue: String;
  PDepartment, PDescription: String;

 // Count, ArrayLimit: integer; // �� ������������

  i : Integer;
 // JSONArray: TJSONArray;
 // JSONNestedObject: TJSONObject;
  Str: String;
  f : TextFile;

  Rec2: RecParams;
begin
 // Count :=1; //���������� ���������� ��������(������)
 // ArrayLimit :=5000; //���������� ��� � json

  CategoryName:= '���������� ';
  PName:= '����� ';
  PValue:= '���������� ';
  PDepartment:= '����� ';
  PDescription:= '������ ';

  try
      JSON := TJSONObject.Create;
    try
      if (SaveDialog1.Execute = True) then
      begin
        AssignFile(f,SaveDialog1.FileName);
        Rewrite(f);
      end;

      with ADOTable1 do
      begin
        First;
        DisableControls;

        for i:=1 to RecordCount do
        begin
          with Rec2 do
          begin
            ID:=FieldByName('categoryID').Value;
            Name:=FieldByName('categoryName').Value;
            Department:=FieldByName('departmentID').Value;
            Description:=FieldByName('description').Value;

            JSON.AddPair(PName + Name, PValue + ID);
            JSON.AddPair(PDepartment + Department,PDescription + Description);
          end;

          Next;
        end;

        Str := JSON.Format(4);
        Writeln(f, Str);

        ADOTable1.UpdateBatch(arAll);
        First;
        EnableControls;
      end;
    except
      on E: EInOutError do
         ShowMessage('������ ��� ������ �����.')
      else
         ShowMessage('������ ��� �������� �����: ' + SaveDialog1.FileName);
    end;
  finally
      CloseFile(f);
      FreeAndNil(JSON);
  end;

end;

procedure TfmFormServer.btnOpenFIleClick(Sender: TObject);
var
  file1: TextFile;
  S: String;
begin
  try
    if (OpenDialog1.Execute()) then
    begin
      Memo1.Enabled:=false;
      Memo1.Lines.Clear;
      AssignFile(file1,OpenDialog1.FileName);
      Reset(file1);
      while Not EOF(file1) do
      begin
        Readln(file1, S);
        Memo1.Lines.Add(S);
      end;
      CloseFile(file1);
      Memo1.Enabled:=true;
    end;
  except
    on E: EInOutError do
       ShowMessage('������ ��� ������ �����.')
    else
       ShowMessage('������ ��� �������� �����: ' + OpenDialog1.FileName);
  end;
end;

end.


