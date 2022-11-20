
{ Клиент - серверное приложение, Карташёв Андрей Юрьевич, 20 ноября 2022 года.
  Тестовое задание в компанию "МТГ Бизнес решения".

   Форма клиента: fmFormClient.

1. При нажатии на кнопку "Запрос данных на сервер", клиент запрашивает данные (передавая поля, соответственно ID и Name).

2. Затем - принимает запрошенные данные с сервера - по номеру ID и/или полю Name. Если
значения полей совпадают в разных записях в БД, то прислаются обе записи.

3. Данные передаются построчно и попадают в Memo (memData).

4. По нажатию на кнопку "В таблицу" или клике мышкой на Memo данные попадают в таблицу (StringGrid).

4. Далее Сохранение:
   1) При нажатии на кнопку "Сохранить" пишет в файл JSON.
   2) Каждая запись в таблице (запрос) - в отдельный файл, или все запросы в один.
   3) "На лету" - когда приходит строка в ответ на запрос.

   Есть возможность открыть и посмотреть файлы .JSON (с данными).

5. Многопоточно:

 + Обрабатываем сообщение - прием строки с сервера.
 + Каждое сообщение - в своем потоке.
 + И передаем строку для загрузки в файл - другой поток.

 Классы потоков - в unite Threads.pas.
 Сервер - FormServer.pas.
 Клиент - FormClient.pas.
}

unit FormClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, System.JSON, Threads;

type
  TfmFormClient = class(TForm)
    edID: TEdit;
    memData: TMemo;
    btnSend: TButton;
    btnSaveToFIle: TButton;
    StringGridData: TStringGrid;

    Label1: TLabel;
    Bevel1: TBevel;
    Panel1: TPanel;
    SaveDialog1: TSaveDialog;
    Label2: TLabel;
    Label3: TLabel;
    edName: TEdit;
    btnGrid: TButton;
    OpenDialog1: TOpenDialog;
    Label4: TLabel;
    RadioGroup1: TRadioGroup;
    Memo1: TMemo;
    Panel2: TPanel;
    btnOpenFromFile: TButton;
    Button2: TButton;
    Button3: TButton;
    edData: TEdit;

    procedure btnSendClick(Sender: TObject);
    procedure btnSaveToFIleClick(Sender: TObject);
    procedure SendText(str: String);
    procedure SaveToFile(RecStr: String);
    procedure memDataClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOpenFromFileClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);

  type
    RecParams = record
      ID, Name, Department, Description : String;
    end;

  private
      procedure ReceiveText(var MessageData: TWMCopyData); message WM_COPYDATA;

  public
    { Public declarations }
    thrNumber: TSaveThreadObj;
    thrReceive : TReceiveThreadObj;
    thrSave : TSaveFileThreadObj;

    ReceivedStr : String;
  end;

const
  CMD_SETLABELTEXT = 1; //Задаем ID команды
  Count = 1; //количество повторений выгрузки(файлов)
  ArrayLimit = 5000; //количество пар в json

  CategoryName = 'Категория ';
  PName = 'Товар: ';
  PValue = 'Количество: ';
  PDepartment = 'Департамент ID: ';
  PDescription = 'Описание товара: ';

var
  fmFormClient: TfmFormClient;
  sgDataRowCount : integer;
  FieldCount : Integer; // количество полей в каждой записи

  JSON1, JSON: TJSONObject;
  INT_REQUEST, INT_RESPONCE : INTEGER;

implementation

{$R *.dfm}

procedure TfmFormClient.FormActivate(Sender: TObject);
begin
  sgDataRowCount := 1;
  FieldCount := 4; // количество полей в ответе на запрос
  INT_REQUEST := 0; // КОЛИЧЕСТВО ЗАПРОСОВ
  INT_RESPONCE :=0; // КОЛИЧЕСТВО ОТВЕТОВ

  StringGridData.Cells[1,1]:='Category ID';
  StringGridData.Cells[2,1]:='Category Name';
  StringGridData.Cells[3,1]:='Department ID';
  StringGridData.Cells[4,1]:='Description';
end;

procedure TfmFormClient.btnOpenFromFileClick(Sender: TObject);
var
  file1: TextFile;
  S: String;

begin
  try
    if (OpenDialog1.Execute()) then
    begin
      Memo1.Lines.Clear;
      AssignFile(file1,OpenDialog1.FileName);
      Reset(file1);
      while Not EOF(file1) do
      begin
       Readln(file1, S);
       Memo1.Lines.Add(S);
      end;
    end;
    CloseFile(file1);
  except
    on E: EInOutError do
      ShowMessage('Ошибка при выборе файла.')
    else
      ShowMessage('Ошибка при открытии файла: ' + OpenDialog1.FileName)
  end;
end;

procedure TfmFormClient.btnSendClick(Sender: TObject);
begin
  SendText(edID.Text);
  SendText(edName.Text);

  INT_REQUEST := INT_REQUEST + 1; // КОЛИЧЕСТВО ответов
end;

// Посылаем строку на сервер
procedure TfmFormClient.SendText(str: String);
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
    SendMessage(FindWindow(nil,'Business Server'),
                  WM_COPYDATA, Handle, Integer(@CDS));
  finally
    //Высвобождаем буфер
    FreeMem(CDS.lpData, CDS.cbData);
  end;
end;

// Обрабатываем сообщение - прием строки с сервера
// Каждое сообщение - в своем потоке.
// И передаем строку для загрузки в файл - другой поток.

procedure TfmFormClient.ReceiveText(var MessageData: TWMCopyData);
begin
  thrReceive:=TReceiveThreadObj.Create(true);
  thrReceive.Resume; // Запускаем поток
  thrReceive.Priority:=tpLower;

  //Устанавливаем свойства метки, если заданная команда совпадает
  ReceivedStr := '';
  if MessageData.CopyDataStruct.dwData = CMD_SETLABELTEXT then
  begin

  //Устанавливаем текст из полученных данных
    ReceivedStr := PAnsiChar(MessageData.CopyDataStruct.lpData);

    INT_RESPONCE := INT_RESPONCE + 1; // КОЛИЧЕСТВО ответов
    memData.Lines.Add(ReceivedStr);

    if (RadioGroup1.ItemIndex = 0) then
      SaveToFile(ReceivedStr); //Сохраняем в файл "на лету"

    MessageData.Result := 1;
  end
  else
    MessageData.Result := 0;

  thrReceive.Terminate;
end;

//Сохраняем в файл "на лету"
procedure TfmFormClient.SaveToFile(RecStr: String);
var
  f: TextFile;
  Str : String;

begin
  try
    thrSave:=TSaveFileThreadObj.Create(true);
    thrSave.Resume;
    thrSave.Priority:=tpLower;

    JSON := TJSONObject.Create;

    AssignFile(f, ExtractFilePath(Application.ExeName)+ '\Small_Files\small_file_record_'+ IntToStr(INT_RESPONCE)+'_'+DateToStr(Now())+'.json');
    Rewrite(f);
    JSON.AddPair('Категория товара. ','Name = ' + RecStr);

    Str := JSON.Format(4);
    Writeln(f, Str);

    CloseFile(f);
    FreeAndNil(JSON);

    thrSave.Terminate;
  except
    on E: EInOutError do ShowMessage('Ошибка записи в файл.')
    else
      ShowMessage('Ошибка при записи в файл записи: ' + RecStr + '.');
  end;
end;


procedure TfmFormClient.btnSaveToFileClick(Sender: TObject);
var
  Str: String;
  f : TextFile;
  i, j : Integer;
  Records: array[0 .. 30] of RecParams;

begin
  if RadioGroup1.ItemIndex = 1 then // Каждый ответ на запрос данных к серверу - в свой файл
  begin
    for i := 1 to sgDataRowCount-1 do
      begin
        try
           JSON := TJSONObject.Create;

           AssignFile(f,ExtractFilePath(Application.ExeName)+'\Middle_Files\file_record_'+IntToStr(i)+'_'+DateToStr(Now())+'.json');
           Rewrite(f);

           with Records[i-1] do
            begin
             ID:= StringGridData.Cells[1,i+1];
             Name:=StringGridData.Cells[2,i+1];
             Department:=StringGridData.Cells[3,i+1];
             Description:=StringGridData.Cells[4,i+1];

             JSON.AddPair(PName + Name,PValue + ID);
             JSON.AddPair(PDepartment + Department,PDescription + Description);
            end;

           Str := JSON.Format(4);
           Writeln(f, Str);

           CloseFile(f);
           FreeAndNil(JSON);
        except
            on E: EInOutError do ShowMessage('Ошибка записи в файл.')
            else
              ShowMessage('Ошибка при записи в файл записи #' + Records[i-1].ID +'.');
        end;
      end;
  end

  else if RadioGroup1.ItemIndex = 2 then  //Все ответы на запросы данных (в таблице) - в один файл
  begin
    try
      JSON1 := TJSONObject.Create;

      if (SaveDialog1.Execute = True) then
      begin
        AssignFile(f,SaveDialog1.FileName);
        Rewrite(f);
      end;

      for i := 1 to sgDataRowCount-1 do
      begin
         with Records[i-1] do
         begin
            ID:= StringGridData.Cells[1,i+1];
            Name:=StringGridData.Cells[2,i+1];
            Department:=StringGridData.Cells[3,i+1];
            Description:=StringGridData.Cells[4,i+1];

            JSON1.AddPair(PName + Name,PValue + ID);
            JSON1.AddPair(PDepartment + Department,PDescription + Description);
         end;
      end;

      Str := JSON1.Format(4);
      Writeln(f, Str);

      CloseFile(f);
      FreeAndNil(JSON1);
    except
        on E: EInOutError do ShowMessage('Ошибка записи в файл.')
        else
           ShowMessage('Ошибка при записи в файл записи #' + Records[i-1].ID + '.');
    end;
  end;
end;


procedure TfmFormClient.Button2Click(Sender: TObject);
begin
  thrNumber:=TSaveThreadObj.Create(true);
  thrNumber.Resume;
  thrNumber.Priority:=tpLower;
end;

procedure TfmFormClient.Button3Click(Sender: TObject);
begin
  thrNumber.Terminate;
end;

// Перенос данных из memData в таблицу
procedure TfmFormClient.memDataClick(Sender: TObject);
var
  i, j : Integer;
  HighValue, HV : Integer;  //количество записей в Memo
  Number : Extended;

begin
   Number := memData.Lines.Count/4;
   if ((Number = 1) or (Number = 2) or (Number = 3) or (Number = 4) or (Number = 5)) then
      HighValue :=  StrToInt(Number.ToString)
   else
   begin
      HighValue := 0;
      //ShowMessage('Неправильные данные в тексте Memo.');
   end;

   if (HighValue<>0) then
   begin
     for i := sgDataRowCount to (sgDataRowCount + HighValue - 1) do
     begin
       StringGridData.Rows[i].Add('');
       HV := HighValue;

       if (HV = 1) then
       begin
         for j:=1 to FieldCount do
            StringGridData.Cells[j,sgDataRowCount+1]:= memData.Lines[j-1+(HV-1)*FieldCount];

         StringGridData.RowCount:=StringGridData.RowCount + 1;
       end;

       if (HV = 2) then
       begin
         for j:=1 to FieldCount do
            StringGridData.Cells[j,sgDataRowCount+1]:= memData.Lines[j-1+(HV-2)*FieldCount];

         for j:=1 to FieldCount do
            StringGridData.Cells[j,sgDataRowCount+2]:= memData.Lines[j-1+(HV-1)*FieldCount];

         StringGridData.RowCount:=StringGridData.RowCount + 1;

       end;

       if (HV = 3) then
       begin
         for j:=1 to 4 do
            StringGridData.Cells[j,sgDataRowCount+1]:= memData.Lines[j-1+(HV-3)*FieldCount];

         for j:=1 to 4 do
            StringGridData.Cells[j,sgDataRowCount+2]:= memData.Lines[j-1+(HV-2)*FieldCount];

         for j:=1 to 4 do
            StringGridData.Cells[j,sgDataRowCount+3]:= memData.Lines[j-1+(HV-1)*FieldCount];

         StringGridData.RowCount:=StringGridData.RowCount + 1;

       end;

       if (HV = 4) then
       begin
         for j:=1 to 4 do
            StringGridData.Cells[j,sgDataRowCount+1]:= memData.Lines[j-1+(HV-4)*FieldCount];

         for j:=1 to 4 do
            StringGridData.Cells[j,sgDataRowCount+2]:= memData.Lines[j-1+(HV-3)*FieldCount];

         for j:=1 to 4 do
            StringGridData.Cells[j,sgDataRowCount+3]:= memData.Lines[j-1+(HV-2)*FieldCount];

         for j:=1 to 4 do
            StringGridData.Cells[j,sgDataRowCount+4]:= memData.Lines[j-1+(HV-1)*FieldCount];

         StringGridData.RowCount:=StringGridData.RowCount + 1;

       end;

       if (HV = 5) then
       begin
         for j:=1 to 4 do
            StringGridData.Cells[j,sgDataRowCount+1]:= memData.Lines[j-1+(HV-5)*FieldCount];

         for j:=1 to 4 do
            StringGridData.Cells[j,sgDataRowCount+2]:= memData.Lines[j-1+(HV-4)*FieldCount];

         for j:=1 to 4 do
            StringGridData.Cells[j,sgDataRowCount+3]:= memData.Lines[j-1+(HV-3)*FieldCount];

         for j:=1 to 4 do
            StringGridData.Cells[j,sgDataRowCount+4]:= memData.Lines[j-1+(HV-2)*FieldCount];

         for j:=1 to 4 do
            StringGridData.Cells[j,sgDataRowCount+5]:= memData.Lines[j-1+(HV-1)*FieldCount];

         StringGridData.RowCount:=StringGridData.RowCount + 1;
       end;
     end;
     sgDataRowCount := i;
     memData.Lines.Clear;
   end;
end;

end.
