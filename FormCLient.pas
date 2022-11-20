
{ ������ - ��������� ����������, �������� ������ �������, 20 ������ 2022 ����.
  �������� ������� � �������� "��� ������ �������".

   ����� �������: fmFormClient.

1. ��� ������� �� ������ "������ ������ �� ������", ������ ����������� ������ (��������� ����, �������������� ID � Name).

2. ����� - ��������� ����������� ������ � ������� - �� ������ ID �/��� ���� Name. ����
�������� ����� ��������� � ������ ������� � ��, �� ���������� ��� ������.

3. ������ ���������� ��������� � �������� � Memo (memData).

4. �� ������� �� ������ "� �������" ��� ����� ������ �� Memo ������ �������� � ������� (StringGrid).

4. ����� ����������:
   1) ��� ������� �� ������ "���������" ����� � ���� JSON.
   2) ������ ������ � ������� (������) - � ��������� ����, ��� ��� ������� � ����.
   3) "�� ����" - ����� �������� ������ � ����� �� ������.

   ���� ����������� ������� � ���������� ����� .JSON (� �������).

5. ������������:

 + ������������ ��������� - ����� ������ � �������.
 + ������ ��������� - � ����� ������.
 + � �������� ������ ��� �������� � ���� - ������ �����.

 ������ ������� - � unite Threads.pas.
 ������ - FormServer.pas.
 ������ - FormClient.pas.
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
  CMD_SETLABELTEXT = 1; //������ ID �������
  Count = 1; //���������� ���������� ��������(������)
  ArrayLimit = 5000; //���������� ��� � json

  CategoryName = '��������� ';
  PName = '�����: ';
  PValue = '����������: ';
  PDepartment = '����������� ID: ';
  PDescription = '�������� ������: ';

var
  fmFormClient: TfmFormClient;
  sgDataRowCount : integer;
  FieldCount : Integer; // ���������� ����� � ������ ������

  JSON1, JSON: TJSONObject;
  INT_REQUEST, INT_RESPONCE : INTEGER;

implementation

{$R *.dfm}

procedure TfmFormClient.FormActivate(Sender: TObject);
begin
  sgDataRowCount := 1;
  FieldCount := 4; // ���������� ����� � ������ �� ������
  INT_REQUEST := 0; // ���������� ��������
  INT_RESPONCE :=0; // ���������� �������

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
      ShowMessage('������ ��� ������ �����.')
    else
      ShowMessage('������ ��� �������� �����: ' + OpenDialog1.FileName)
  end;
end;

procedure TfmFormClient.btnSendClick(Sender: TObject);
begin
  SendText(edID.Text);
  SendText(edName.Text);

  INT_REQUEST := INT_REQUEST + 1; // ���������� �������
end;

// �������� ������ �� ������
procedure TfmFormClient.SendText(str: String);
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
    SendMessage(FindWindow(nil,'Business Server'),
                  WM_COPYDATA, Handle, Integer(@CDS));
  finally
    //������������ �����
    FreeMem(CDS.lpData, CDS.cbData);
  end;
end;

// ������������ ��������� - ����� ������ � �������
// ������ ��������� - � ����� ������.
// � �������� ������ ��� �������� � ���� - ������ �����.

procedure TfmFormClient.ReceiveText(var MessageData: TWMCopyData);
begin
  thrReceive:=TReceiveThreadObj.Create(true);
  thrReceive.Resume; // ��������� �����
  thrReceive.Priority:=tpLower;

  //������������� �������� �����, ���� �������� ������� ���������
  ReceivedStr := '';
  if MessageData.CopyDataStruct.dwData = CMD_SETLABELTEXT then
  begin

  //������������� ����� �� ���������� ������
    ReceivedStr := PAnsiChar(MessageData.CopyDataStruct.lpData);

    INT_RESPONCE := INT_RESPONCE + 1; // ���������� �������
    memData.Lines.Add(ReceivedStr);

    if (RadioGroup1.ItemIndex = 0) then
      SaveToFile(ReceivedStr); //��������� � ���� "�� ����"

    MessageData.Result := 1;
  end
  else
    MessageData.Result := 0;

  thrReceive.Terminate;
end;

//��������� � ���� "�� ����"
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
    JSON.AddPair('��������� ������. ','Name = ' + RecStr);

    Str := JSON.Format(4);
    Writeln(f, Str);

    CloseFile(f);
    FreeAndNil(JSON);

    thrSave.Terminate;
  except
    on E: EInOutError do ShowMessage('������ ������ � ����.')
    else
      ShowMessage('������ ��� ������ � ���� ������: ' + RecStr + '.');
  end;
end;


procedure TfmFormClient.btnSaveToFileClick(Sender: TObject);
var
  Str: String;
  f : TextFile;
  i, j : Integer;
  Records: array[0 .. 30] of RecParams;

begin
  if RadioGroup1.ItemIndex = 1 then // ������ ����� �� ������ ������ � ������� - � ���� ����
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
            on E: EInOutError do ShowMessage('������ ������ � ����.')
            else
              ShowMessage('������ ��� ������ � ���� ������ #' + Records[i-1].ID +'.');
        end;
      end;
  end

  else if RadioGroup1.ItemIndex = 2 then  //��� ������ �� ������� ������ (� �������) - � ���� ����
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
        on E: EInOutError do ShowMessage('������ ������ � ����.')
        else
           ShowMessage('������ ��� ������ � ���� ������ #' + Records[i-1].ID + '.');
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

// ������� ������ �� memData � �������
procedure TfmFormClient.memDataClick(Sender: TObject);
var
  i, j : Integer;
  HighValue, HV : Integer;  //���������� ������� � Memo
  Number : Extended;

begin
   Number := memData.Lines.Count/4;
   if ((Number = 1) or (Number = 2) or (Number = 3) or (Number = 4) or (Number = 5)) then
      HighValue :=  StrToInt(Number.ToString)
   else
   begin
      HighValue := 0;
      //ShowMessage('������������ ������ � ������ Memo.');
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
