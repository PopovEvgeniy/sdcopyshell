unit sdcopyshellcode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,LCLType ,FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure LabeledEdit2Change(Sender: TObject);
    procedure LabeledEdit3Change(Sender: TObject);
    procedure LabeledEdit3KeyPress(Sender: TObject; var Key: char);
    procedure LabeledEdit4Change(Sender: TObject);
    procedure LabeledEdit4KeyPress(Sender: TObject; var Key: char);
    procedure LabeledEdit5KeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  end;

var Form1: TForm1;
function get_path():string;
function convert_file_name(source:string):string;
function execute_program(executable:string;argument:string):Integer;
procedure window_setup();
procedure dialog_setup();
procedure interface_setup();
procedure set_default();
procedure do_job(source:string;target:string;buffer:string;start:string;stop:string);
function check_input(input:string):Boolean;
procedure restrict_input(var key:char);

implementation

function get_path():string;
begin
get_path:=ExtractFilePath(Application.ExeName);
end;

function convert_file_name(source:string):string;
var target:string;
begin
target:=source;
if Pos(' ',source)>0 then
begin
target:='"';
target:=target+source+'"';
end;
convert_file_name:=target;
end;

function execute_program(executable:string;argument:string):Integer;
var parametrs:string;
var code:Integer;
begin
parametrs:=UTF8ToSys(argument);
try
code:=ExecuteProcess(executable,parametrs,[]);
except
On EOSError do code:=-1;
end;
execute_program:=code;
end;

procedure window_setup();
begin
 Application.Title:='SIMPLE DATA COPIER SHELL';
 Form1.Caption:='SIMPLE DATA COPIER SHELL 0.4';
 Form1.BorderStyle:=bsDialog;
 Form1.Font.Name:=Screen.MenuFont.Name;
 Form1.Font.Size:=14;
end;

procedure dialog_setup();
begin
Form1.OpenDialog1.Title:='Open a file';
Form1.SaveDialog1.Title:='Save a file';
Form1.OpenDialog1.FileName:='';
Form1.OpenDialog1.Filter:='All files|*.*';
Form1.OpenDialog1.DefaultExt:=Form1.OpenDialog1.FileName;
Form1.SaveDialog1.DefaultExt:=Form1.OpenDialog1.DefaultExt;
Form1.SaveDialog1.FileName:=Form1.OpenDialog1.FileName;
Form1.SaveDialog1.Filter:=Form1.OpenDialog1.Filter;
end;

procedure interface_setup();
begin
Form1.LabeledEdit1.LabelPosition:=lpLeft;
Form1.LabeledEdit2.LabelPosition:=Form1.LabeledEdit1.LabelPosition;
Form1.LabeledEdit3.LabelPosition:=Form1.LabeledEdit1.LabelPosition;
Form1.LabeledEdit4.LabelPosition:=Form1.LabeledEdit1.LabelPosition;
Form1.LabeledEdit5.LabelPosition:=Form1.LabeledEdit1.LabelPosition;
Form1.LabeledEdit1.Enabled:=False;
Form1.LabeledEdit2.Enabled:=Form1.LabeledEdit1.Enabled;
Form1.LabeledEdit1.Text:='';
Form1.LabeledEdit2.Text:=Form1.LabeledEdit1.Text;
Form1.Button1.ShowHint:=False;
Form1.Button2.ShowHint:=Form1.Button1.ShowHint;
Form1.Button3.ShowHint:=Form1.Button1.ShowHint;
Form1.Button3.Enabled:=False;
Form1.LabeledEdit1.EditLabel.Caption:='Source file';
Form1.LabeledEdit2.EditLabel.Caption:='Target file';
Form1.LabeledEdit3.EditLabel.Caption:='Buffer length(in megabytes)';
Form1.LabeledEdit4.EditLabel.Caption:='Start offset(in bytes)';
Form1.LabeledEdit5.EditLabel.Caption:='End offset(in bytes)';
Form1.Button1.Caption:='Open';
Form1.Button2.Caption:='Set';
Form1.Button3.Caption:='Start';
end;

procedure set_default();
begin
Form1.LabeledEdit3.Text:='8';
Form1.LabeledEdit4.Text:='1';
Form1.LabeledEdit5.Text:='';
end;

procedure do_job(source:string;target:string;buffer:string;start:string;stop:string);
var messages:array[0..12] of string=('Operation successfully complete','Can not open input file','Can not create or open output file','Can not allocate memory','Can not decode argument','Buffer length is too small','Buffer length is too big','Input files with zero length not supported','Invalid offset','Invalid start offset! Minimal start offset:1','Can not jump to start offset','Can not read data','Can not write data');
var message:SmallInt;
var host,job:string;
begin
host:=get_path()+'sdcopy';
job:=convert_file_name(source)+' '+convert_file_name(target)+' '+buffer+' '+start+' '+stop;
message:=execute_program(host,job);
if message<0 then
begin
ShowMessage('Can not execute a external program');
end
else
begin
ShowMessage(messages[message]);
end;

end;

function check_input(input:string):Boolean;
var target:Boolean;
begin
target:=True;
if input='' then
begin
target:=False;
end;
check_input:=target;
end;

procedure restrict_input(var key:char);
begin
if (ord(key)<ord('0')) or (ord(key)>ord('9')) then
begin
if ord(key)<>VK_BACK then
begin
key:=#0;
end;

end;

end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
window_setup();
dialog_setup();
interface_setup();
set_default();
end;

procedure TForm1.LabeledEdit1Change(Sender: TObject);
begin
Form1.Button3.Enabled:=check_input(Form1.LabeledEdit1.Text) and check_input(Form1.LabeledEdit2.Text) and check_input(Form1.LabeledEdit3.Text) and check_input(Form1.LabeledEdit4.Text);
end;

procedure TForm1.LabeledEdit2Change(Sender: TObject);
begin
Form1.Button3.Enabled:=check_input(Form1.LabeledEdit1.Text) and check_input(Form1.LabeledEdit2.Text) and check_input(Form1.LabeledEdit3.Text) and check_input(Form1.LabeledEdit4.Text);
end;

procedure TForm1.LabeledEdit3Change(Sender: TObject);
begin
Form1.Button3.Enabled:=check_input(Form1.LabeledEdit1.Text) and check_input(Form1.LabeledEdit2.Text) and check_input(Form1.LabeledEdit3.Text) and check_input(Form1.LabeledEdit4.Text);
end;

procedure TForm1.LabeledEdit3KeyPress(Sender: TObject; var Key: char);
begin
restrict_input(Key);
end;

procedure TForm1.LabeledEdit4Change(Sender: TObject);
begin
Form1.Button3.Enabled:=check_input(Form1.LabeledEdit1.Text) and check_input(Form1.LabeledEdit2.Text) and check_input(Form1.LabeledEdit3.Text) and check_input(Form1.LabeledEdit4.Text);
end;

procedure TForm1.LabeledEdit4KeyPress(Sender: TObject; var Key: char);
begin
restrict_input(Key);
end;

procedure TForm1.LabeledEdit5KeyPress(Sender: TObject; var Key: char);
begin
restrict_input(Key);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
if Form1.OpenDialog1.Execute()=True then
begin
Form1.LabeledEdit1.Text:=Form1.OpenDialog1.FileName;
set_default();
end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
if Form1.SaveDialog1.Execute()=True then
begin
Form1.LabeledEdit2.Text:=Form1.SaveDialog1.FileName;
end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
do_job(Form1.LabeledEdit1.Text,Form1.LabeledEdit2.Text,Form1.LabeledEdit3.Text,Form1.LabeledEdit4.Text,Form1.LabeledEdit5.Text);
end;

end.
