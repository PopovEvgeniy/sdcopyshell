unit sdcopyshellcode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LazFileUtils;

type

  { TMainWindow }

  TMainWindow = class(TForm)
    OpenButton: TButton;
    SetButton: TButton;
    StartButton: TButton;
    SourceField: TLabeledEdit;
    TargetField: TLabeledEdit;
    StartField: TLabeledEdit;
    EndField: TLabeledEdit;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    procedure OpenButtonClick(Sender: TObject);
    procedure SetButtonClick(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SourceFieldChange(Sender: TObject);
    procedure TargetFieldChange(Sender: TObject);
    procedure StartFieldChange(Sender: TObject);
    procedure EndFieldChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var MainWindow: TMainWindow;

implementation

function convert_file_name(const source:string):string;
var target:string;
begin
 target:=source;
 if Pos(' ',source)>0 then
 begin
  target:='"'+source+'"';
 end;
 convert_file_name:=target;
end;

function execute_program(const executable:string;const argument:string):Integer;
var code:Integer;
begin
 try
  code:=ExecuteProcess(executable,argument,[]);
 except
  code:=-1;
 end;
 execute_program:=code;
end;

procedure do_job(const source:string;const target:string;const start:string;const stop:string);
var messages:array[0..10] of string=('Operation was successfully completed','Can not open the input file','Can not create or open the output file','Can not allocate memory','Can not decode an argument','An input file with zero length is not supported','Invalid offset','Invalid start offset! Minimal start offset:1','Can not jump to the start offset','Can not read data','Can not write data');
var id:Integer;
var host,job,message:string;
begin
 message:='Can not execute an external program';
 host:=ExtractFilePath(Application.ExeName)+'sdcopy.exe';
 job:=convert_file_name(source)+' '+convert_file_name(target)+' '+start+' '+stop;
 id:=execute_program(host,job);
 if id>=0 then
 begin
  message:=messages[id];
 end;
 ShowMessage(message);
end;

procedure window_setup();
begin
 Application.Title:='Simple data copier shell';
 MainWindow.Caption:='Simple data copier shell 0.6.7';
 MainWindow.BorderStyle:=bsDialog;
 MainWindow.Font.Name:=Screen.MenuFont.Name;
 MainWindow.Font.Size:=14;
end;

procedure dialog_setup();
begin
 MainWindow.OpenDialog.FileName:='';
 MainWindow.OpenDialog.DefaultExt:=MainWindow.OpenDialog.FileName;
 MainWindow.SaveDialog.DefaultExt:=MainWindow.OpenDialog.DefaultExt;
 MainWindow.SaveDialog.FileName:=MainWindow.OpenDialog.FileName;
 MainWindow.SaveDialog.Filter:=MainWindow.OpenDialog.Filter;
end;

procedure interface_setup();
begin
 MainWindow.StartField.NumbersOnly:=True;
 MainWindow.EndField.NumbersOnly:=True;
 MainWindow.SourceField.LabelPosition:=lpLeft;
 MainWindow.TargetField.LabelPosition:=MainWindow.SourceField.LabelPosition;
 MainWindow.StartField.LabelPosition:=MainWindow.SourceField.LabelPosition;
 MainWindow.EndField.LabelPosition:=MainWindow.SourceField.LabelPosition;
 MainWindow.SourceField.Enabled:=False;
 MainWindow.TargetField.Enabled:=MainWindow.SourceField.Enabled;
 MainWindow.SourceField.Text:='';
 MainWindow.TargetField.Text:=MainWindow.SourceField.Text;
 MainWindow.OpenButton.ShowHint:=False;
 MainWindow.SetButton.ShowHint:=MainWindow.OpenButton.ShowHint;
 MainWindow.StartButton.ShowHint:=MainWindow.OpenButton.ShowHint;
 MainWindow.StartButton.Enabled:=False;
end;

procedure language_setup();
begin
 MainWindow.OpenDialog.Title:='Open a file';
 MainWindow.SaveDialog.Title:='Save a file';
 MainWindow.OpenDialog.Filter:='All files|*.*';
 MainWindow.SourceField.EditLabel.Caption:='Source file';
 MainWindow.TargetField.EditLabel.Caption:='Target file';
 MainWindow.StartField.EditLabel.Caption:='Start offset(in bytes)';
 MainWindow.EndField.EditLabel.Caption:='End offset(in bytes)';
 MainWindow.OpenButton.Caption:='Open';
 MainWindow.SetButton.Caption:='Set';
 MainWindow.StartButton.Caption:='Start';
end;

procedure set_default();
begin
 MainWindow.StartField.Text:='1';
 MainWindow.EndField.Text:='';
end;

procedure setup();
begin
 window_setup();
 interface_setup();
 language_setup();
 dialog_setup();
 set_default();
end;

{$R *.lfm}

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TMainWindow.SourceFieldChange(Sender: TObject);
begin
 MainWindow.StartButton.Enabled:=(MainWindow.SourceField.Text<>'') and (MainWindow.TargetField.Text<>'');
end;

procedure TMainWindow.TargetFieldChange(Sender: TObject);
begin
 MainWindow.StartButton.Enabled:=(MainWindow.SourceField.Text<>'') and (MainWindow.TargetField.Text<>'');
end;

procedure TMainWindow.StartFieldChange(Sender: TObject);
begin
 if MainWindow.StartField.Text='' then
 begin
  MainWindow.EndField.Text:='';
 end;

end;

procedure TMainWindow.EndFieldChange(Sender: TObject);
begin
 if MainWindow.StartField.Text='' then
 begin
  MainWindow.EndField.Text:='';
 end;

end;

procedure TMainWindow.OpenButtonClick(Sender: TObject);
begin
if MainWindow.OpenDialog.Execute()=True then
begin
 MainWindow.SourceField.Text:=MainWindow.OpenDialog.FileName;
 set_default();
end;

end;

procedure TMainWindow.SetButtonClick(Sender: TObject);
begin
 if MainWindow.SaveDialog.Execute()=True then MainWindow.TargetField.Text:=MainWindow.SaveDialog.FileName;
end;

procedure TMainWindow.StartButtonClick(Sender: TObject);
begin
 do_job(MainWindow.SourceField.Text,MainWindow.TargetField.Text,MainWindow.StartField.Text,MainWindow.EndField.Text);
end;

end.
