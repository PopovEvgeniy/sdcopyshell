unit sdcopyshellcode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LazFileUtils;

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
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure LabeledEdit2Change(Sender: TObject);
    procedure LabeledEdit3Change(Sender: TObject);
    procedure LabeledEdit4Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var Form1: TForm1;

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
 Application.Title:='SIMPLE DATA COPIER SHELL';
 Form1.Caption:='SIMPLE DATA COPIER SHELL 0.6.5';
 Form1.BorderStyle:=bsDialog;
 Form1.Font.Name:=Screen.MenuFont.Name;
 Form1.Font.Size:=14;
end;

procedure dialog_setup();
begin
 Form1.OpenDialog1.FileName:='';
 Form1.OpenDialog1.DefaultExt:=Form1.OpenDialog1.FileName;
 Form1.SaveDialog1.DefaultExt:=Form1.OpenDialog1.DefaultExt;
 Form1.SaveDialog1.FileName:=Form1.OpenDialog1.FileName;
 Form1.SaveDialog1.Filter:=Form1.OpenDialog1.Filter;
end;

procedure interface_setup();
begin
 Form1.LabeledEdit3.NumbersOnly:=True;
 Form1.LabeledEdit4.NumbersOnly:=True;
 Form1.LabeledEdit1.LabelPosition:=lpLeft;
 Form1.LabeledEdit2.LabelPosition:=Form1.LabeledEdit1.LabelPosition;
 Form1.LabeledEdit3.LabelPosition:=Form1.LabeledEdit1.LabelPosition;
 Form1.LabeledEdit4.LabelPosition:=Form1.LabeledEdit1.LabelPosition;
 Form1.LabeledEdit1.Enabled:=False;
 Form1.LabeledEdit2.Enabled:=Form1.LabeledEdit1.Enabled;
 Form1.LabeledEdit1.Text:='';
 Form1.LabeledEdit2.Text:=Form1.LabeledEdit1.Text;
 Form1.Button1.ShowHint:=False;
 Form1.Button2.ShowHint:=Form1.Button1.ShowHint;
 Form1.Button3.ShowHint:=Form1.Button1.ShowHint;
 Form1.Button3.Enabled:=False;
end;

procedure language_setup();
begin
 Form1.OpenDialog1.Title:='Open a file';
 Form1.SaveDialog1.Title:='Save a file';
 Form1.OpenDialog1.Filter:='All files|*.*';
 Form1.LabeledEdit1.EditLabel.Caption:='Source file';
 Form1.LabeledEdit2.EditLabel.Caption:='Target file';
 Form1.LabeledEdit3.EditLabel.Caption:='Start offset(in bytes)';
 Form1.LabeledEdit4.EditLabel.Caption:='End offset(in bytes)';
 Form1.Button1.Caption:='Open';
 Form1.Button2.Caption:='Set';
 Form1.Button3.Caption:='Start';
end;

procedure set_default();
begin
 Form1.LabeledEdit3.Text:='1';
 Form1.LabeledEdit4.Text:='';
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

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TForm1.LabeledEdit1Change(Sender: TObject);
begin
 Form1.Button3.Enabled:=(Form1.LabeledEdit1.Text<>'') and (Form1.LabeledEdit2.Text<>'');
end;

procedure TForm1.LabeledEdit2Change(Sender: TObject);
begin
 Form1.Button3.Enabled:=(Form1.LabeledEdit1.Text<>'') and (Form1.LabeledEdit2.Text<>'');
end;

procedure TForm1.LabeledEdit3Change(Sender: TObject);
begin
 if Form1.LabeledEdit3.Text='' then
 begin
  Form1.LabeledEdit4.Text:='';
 end;

end;

procedure TForm1.LabeledEdit4Change(Sender: TObject);
begin
 if Form1.LabeledEdit3.Text='' then
 begin
  Form1.LabeledEdit4.Text:='';
 end;

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
 if Form1.SaveDialog1.Execute()=True then Form1.LabeledEdit2.Text:=Form1.SaveDialog1.FileName;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 do_job(Form1.LabeledEdit1.Text,Form1.LabeledEdit2.Text,Form1.LabeledEdit3.Text,Form1.LabeledEdit4.Text);
end;

end.
