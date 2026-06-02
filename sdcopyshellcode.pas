unit sdcopyshellcode;

{
 This sofware was made by Popov Evgeniy Alekseyevich.
 It is distributed under the GNU GENERAL PUBLIC LICENSE (Version 2 or higher).
}

{$mode objfpc}
{$H+}

interface

uses Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TMainWindow }

  TMainWindow = class(TForm)
    OpenButton: TButton;
    SetButton: TButton;
    StartButton: TButton;
    SourceField: TLabeledEdit;
    TargetField: TLabeledEdit;
    StartField: TLabeledEdit;
    BlockField: TLabeledEdit;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    procedure OpenButtonClick(Sender: TObject);
    procedure SetButtonClick(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SourceFieldChange(Sender: TObject);
    procedure TargetFieldChange(Sender: TObject);
    procedure StartFieldChange(Sender: TObject);
  private
    procedure window_setup();
    procedure dialog_setup();
    procedure interface_setup();
    procedure language_setup();
    procedure set_default();
    procedure setup();
  public
    { public declarations }
  end;

var MainWindow: TMainWindow;

implementation

procedure TMainWindow.window_setup();
begin
 Application.Title:='Simple data copier shell';
 Self.Caption:='Simple data copier shell 0.7.5';
 Self.BorderStyle:=bsDialog;
 Self.Font.Name:=Screen.MenuFont.Name;
 Self.Font.Size:=14;
end;

procedure TMainWindow.dialog_setup();
begin
 Self.OpenDialog.FileName:='';
 Self.OpenDialog.DefaultExt:=Self.OpenDialog.FileName;
 Self.SaveDialog.DefaultExt:=Self.OpenDialog.DefaultExt;
 Self.SaveDialog.FileName:=Self.OpenDialog.FileName;
 Self.SaveDialog.Filter:=Self.OpenDialog.Filter;
end;

procedure TMainWindow.interface_setup();
begin
 Self.StartField.NumbersOnly:=True;
 Self.BlockField.NumbersOnly:=True;
 Self.SourceField.LabelPosition:=lpLeft;
 Self.TargetField.LabelPosition:=Self.SourceField.LabelPosition;
 Self.StartField.LabelPosition:=Self.SourceField.LabelPosition;
 Self.BlockField.LabelPosition:=Self.SourceField.LabelPosition;
 Self.SourceField.Enabled:=False;
 Self.TargetField.Enabled:=Self.SourceField.Enabled;
 Self.SourceField.Text:='';
 Self.TargetField.Text:=Self.SourceField.Text;
 Self.OpenButton.ShowHint:=False;
 Self.SetButton.ShowHint:=Self.OpenButton.ShowHint;
 Self.StartButton.ShowHint:=Self.OpenButton.ShowHint;
 Self.StartButton.Enabled:=False;
end;

procedure TMainWindow.language_setup();
begin
 Self.OpenDialog.Title:='Open a file';
 Self.SaveDialog.Title:='Save a file';
 Self.OpenDialog.Filter:='All files|*.*';
 Self.SourceField.EditLabel.Caption:='The source file';
 Self.TargetField.EditLabel.Caption:='The target file';
 Self.StartField.EditLabel.Caption:='The start offset(in bytes)';
 Self.BlockField.EditLabel.Caption:='The block length(in bytes)';
 Self.OpenButton.Caption:='Open';
 Self.SetButton.Caption:='Set';
 Self.StartButton.Caption:='Start';
end;

procedure TMainWindow.set_default();
begin
 Self.StartField.Text:='0';
 Self.BlockField.Text:='';
end;

procedure TMainWindow.setup();
begin
 Self.window_setup();
 Self.interface_setup();
 Self.language_setup();
 Self.dialog_setup();
 Self.set_default();
end;

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
var messages:array[0..10] of string=('The operation was successfully completed','Cannot open the input file!','Cannot create or open the output file!','Cannot jump to the start offset!','Cannot read data!','Cannot write data!','The start offset is invalid!','The block length is invalid!','The block length is too large!','Cannot decode an argument','Cannot allocate memory!');
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

{$R *.lfm}

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 Self.setup();
end;

procedure TMainWindow.SourceFieldChange(Sender: TObject);
begin
 Self.StartButton.Enabled:=(Self.SourceField.Text<>'') and (Self.TargetField.Text<>'');
end;

procedure TMainWindow.TargetFieldChange(Sender: TObject);
begin
 Self.StartButton.Enabled:=(Self.SourceField.Text<>'') and (Self.TargetField.Text<>'');
end;

procedure TMainWindow.StartFieldChange(Sender: TObject);
begin
 if Self.StartField.Text='' then
 begin
  Self.BlockField.Text:='';
 end;
 Self.BlockField.Enabled:=Self.StartField.Text<>'';
end;

procedure TMainWindow.OpenButtonClick(Sender: TObject);
begin
if Self.OpenDialog.Execute()=True then
begin
 Self.SourceField.Text:=Self.OpenDialog.FileName;
 Self.set_default();
end;

end;

procedure TMainWindow.SetButtonClick(Sender: TObject);
begin
 if Self.SaveDialog.Execute()=True then Self.TargetField.Text:=Self.SaveDialog.FileName;
end;

procedure TMainWindow.StartButtonClick(Sender: TObject);
begin
 do_job(Self.SourceField.Text,Self.TargetField.Text,Self.StartField.Text,Self.BlockField.Text);
end;

end.
