{ Клиент - серверное приложение, Карташёв Андрей Юрьевич, 20 ноября 2022 года.
  Тестовое задание в компанию "МТГ Бизнес решения".

  Форма Сервера: fmFormServer.

  Классы потоков - в unite Threads.pas.
  Сервер - FormServer.pas.
  Клиент - FormClient.pas.
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
  CMD_SETLABELTEXT = 1; //Задаем ID команды
  MaxCountInserted = 5000;

var
  fmFormServer: TfmFormServer;

implementation

{$R *.dfm}

procedure TfmFormServer.ReceiveData(var MessageData: TWMCopyData);
var
  ReceivedStr : String;

begin
  //Устанавливаем свойства метки, если заданная команда совпадает
  if MessageData.CopyDataStruct.dwData = CMD_SETLABELTEXT then
  begin
    ReceivedStr := PAnsiChar(MessageData.CopyDataStruct.lpData);

  //Устанавливаем текст из полученных данных
    Memo1.Lines.Add(ReceivedStr);

  // Поиск записи и передача данных из БД на клиент построчно
    TableSearch(ReceivedStr);

    MessageData.Result := 1;
  end
  else
    MessageData.Result := 0;
end;

procedure TfmFormServer.TableSearch(Rstr: String);
var
    Rec1: RecParams;
    // запись найдена
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
        ShowMessage('Запись в Базе Данных найдена, ID = ' + Rec1.ID)
      else
        ShowMessage('Запись с такими параметрами не найдена.');
    }

  end;

end;

procedure TfmFormServer.SendText(str: String);
var
  CDS: TCopyDataStruct;
begin
  //Устанавливаем тип команды
  CDS.dwData := CMD_SETLABELTEXT;
  //Устанавливаем длину передаваемых данных
  CDS.cbData := Length(str) + 1;
  //Выделяем память буфера для передачи данных
  GetMem(CDS.lpData, CDS.cbData);
  try
    //Копируем данные в буфер
    StrPCopy(CDS.lpData, AnsiString(str));
    //Отсылаем сообщение в окно с заголовком StringReceiver
    SendMessage(FindWindow(nil,'Business Client'),
                  WM_COPYDATA, Handle, Integer(@CDS));
  finally
    //Высвобождаем буфер
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
      FieldByName('description').Value := 'Текст ' + IntToStr(i);
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
  //выделяем только имя файла, без путей
  SFileName:=ExtractFileName(FileName);
  Memo1.Lines.Add('Uploading ' + SFileName);

  //подготавливаем параметры
  RESTRequest1.Params.Clear;
  RESTRequest1.Params.Add;

  //в первую очередь дополнительный заголовок в запрос
  //с токеном, иначе будет 401 UNAUTHORIZED

  RESTRequest1.Params[0].Kind:=TRESTRequestParameterKind.pkHTTPHEADER;
  RESTRequest1.Params[0].name:='Authorization';
  RESTRequest1.Params[0].Options:=[poDoNotEncode];
  RESTRequest1.Params[0].Value:='OAuth ' + OAuth2Authenticator1.AccessToken;

  //далее - путь загрузки
  //делаем просто в папку приложения

  RESTRequest1.Params.Add;
  RESTRequest1.Params[0].name:='path';
  RESTRequest1.Params[0].Value:='app:/'+SFilename;

  //перезапишем без вопросов
  RESTRequest1.Params.Add;
  RESTRequest1.Params[1].name:='overwrite';
  RESTRequest1.Params[1].Value:='true';

  RESTRequest1.Resource:='/disk/resources/upload';
  RESTRequest1.Method:=rmGet;

  //ну и собственно запрос ссылки на загрузку
  RESTRequest1.Execute;

  if RESTRequest1.Response.StatusCode=200 then begin
    //все нормально, для отладки выведем полученный JSON
    Memo1.Lines.Add(RESTRequest1.Response.Content);

    //выделяем ссылку на загрузку
    Link:=TJSONObject(RESTRequest1.Response.JSONValue).GetValue('href').Value;

    Memo1.lines.add(Link);   //запоминаем базовый путь

    Mem:=RESTClient1.BaseURL;

    try      //прописываем ссылку на загрузку
      RESTClient1.BaseURL:=Link;
      //очищаем параметры, токен при это не нужен       RESTRequest1.Params.Clear;
      RESTRequest1.Resource:='';
      //добавляем файл в запрос
      RESTRequest1.AddFile(FileName);

      //метод - PUT
      RESTRequest1.Method:=rmPUT;      //ну и отправляем файл на сервер
      RESTRequest1.Execute;

    finally
      //после чего восстанавливаем ссылку на API
      RESTClient1.BaseURL:=Mem;
    end;

    Code:=RESTRequest1.Response.StatusCode;
    if Code=201 then Memo1.Lines.Add('файл успешно загружен');
    if Code=202 then Memo1.Lines.Add('файл загружен на сервер, но пока не передан в папку назначения');
    if Code=412 then Memo1.Lines.Add('при дозагрузке файла был передан неверный диапазон в заголовке Content-Range');
    if Code=413 then Memo1.Lines.Add('размер файла превышает 10Гб');
    if Code=500 then Memo1.Lines.Add('внутренняя ошибка сервера, попробуйте позже');
    if Code=503 then Memo1.Lines.Add('сервис недоступен, попробуйте позже');
    if Code=507 then Memo1.Lines.Add('исчерпано место на Диске');

  end else Memo1.Lines.Add('запрос ссылки - ошибка '+RESTRequest1.Response.StatusCode.ToString);
end;

{
Authorization-Endpoint: https://accounts.google.com/o/oauth2/auth
Token-Endpoint: https://accounts.google.com/o/oauth2/token
Redirctioon-Endpoint: urn:ietf:wg:oauth:2.0:oob
Client-ID: значение Client ID вашего проекта
Client-Secret: значение Client Secret вашего проекта
Access-Scope: https://www.googleapis.com/auth/drive

}

procedure TfmFormServer.btnAutorisationClick(Sender: TObject);
var wf: Tfrm_OAuthWebForm;
begin
  //создаем окно с браузером
  //для перенаправления пользователя на страницу Google
  wf:=Tfrm_OAuthWebForm.Create(self);
  try
    //определяем обработчик события смены Title
    wf.OnTitleChanged:=TitleChanged;
    wf.OnAfterRedirect:=AfterRedirect;
    //показываем окно и открываем
    //в браузере URL с формой подтверждения доступа
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

//  Выгрузка в JSON с сервера (из грида).
procedure TfmFormServer.btnSaveToFileClick(Sender: TObject);
var
  JSON: TJSONObject;
  CategoryName : String;
  PName, PValue: String;
  PDepartment, PDescription: String;

 // Count, ArrayLimit: integer; // не используются

  i : Integer;
 // JSONArray: TJSONArray;
 // JSONNestedObject: TJSONObject;
  Str: String;
  f : TextFile;

  Rec2: RecParams;
begin
 // Count :=1; //количество повторений выгрузки(файлов)
 // ArrayLimit :=5000; //количество пар в json

  CategoryName:= 'Покупатель ';
  PName:= 'Товар ';
  PValue:= 'Количество ';
  PDepartment:= 'Отдел ';
  PDescription:= 'Данные ';

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
         ShowMessage('Ошибка при выборе файла.')
      else
         ShowMessage('Ошибка при открытии файла: ' + SaveDialog1.FileName);
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
       ShowMessage('Ошибка при выборе файла.')
    else
       ShowMessage('Ошибка при открытии файла: ' + OpenDialog1.FileName);
  end;
end;

end.


