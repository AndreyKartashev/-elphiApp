// ������ ������� (3)

unit Threads;

interface

uses
  System.Classes, System.SysUtils, Winapi.Windows, Winapi.Messages;

type

  // ����� ������ ��� �������� � EdData �� �������.
  TSaveThreadObj = class(TThread)
  protected
    procedure Execute; override;
  private
    Index: Integer;
    procedure UpdateMemo(Index: Integer);
  end;

  // ����� ������ ��� ������ �����.
  TReceiveThreadObj = class(TThread)
  protected
    procedure Execute; override;
  private
    Data: String;
    procedure ReceiveText();
  end;

  // ��������� ����� ������ ��� ���������� � ���� ������ �� ������ - ������.
  TSaveFileThreadObj = class(TThread)
  protected
    procedure Execute; override;
  private
    Data: String;
    procedure SaveFile();
  end;

implementation

uses FormClient;
{ TSaveThreadObj }

procedure TSaveThreadObj.Execute;
begin
  NameThreadForDebugging('SaveThread1');
  FreeOnTerminate:=true;
  Index:=1;
//��������� ����������� �������
  while Index>0 do
  begin
    SendMessage(fmFormClient.edData.Handle, WM_SETTEXT, 0,
                Integer(PChar(IntToStr(Index))));
    Inc(Index);
    if Index>100000 then
      Index:=0;
      //���� ����� ����������, �� �����,
    if Terminated then exit;
  end;
end;

procedure TSaveThreadObj.UpdateMemo(Index: integer);
begin
  //fmFormClient.memData.Lines.Add(IntToStr(Index));
end;

procedure TReceiveThreadObj.Execute;
begin
  NameThreadForDebugging('SaveThread2');
  FreeOnTerminate:=true;
  Data:=fmFormClient.ReceivedStr;
  Synchronize(ReceiveText);
  //SendMessage(fmFormClient.edData.Handle, WM_SETTEXT, 0, Integer(PChar(Data)));
end;

procedure TReceiveThreadObj.ReceiveText();
begin
  //fmFormClient.memData.Lines.Add(Data);
end;

procedure TSaveFileThreadObj.Execute;
begin
  NameThreadForDebugging('SaveThread3');
  FreeOnTerminate:=true;
  Data:=fmFormClient.ReceivedStr;
  Synchronize(SaveFile);
  //SendMessage(fmFormClient.edData.Handle, WM_SETTEXT, 0, Integer(PChar(Data)));
end;

procedure TSaveFileThreadObj.SaveFile();
begin
  //fmFormClient.memData.Lines.Add(Data);
end;

end.
