unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,QDB,DateUtils,
  Data.DB, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    Panel4: TPanel;
    DBGrid1: TDBGrid;
    Panel5: TPanel;
    Panel6: TPanel;
    DBGrid2: TDBGrid;
    DataSource2: TDataSource;
    DataSource1: TDataSource;
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FSource, FDest: TQDataSet;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
function GetHumanName: String;
const
  // �й��ټ��� (Chinese Last Names)
  FirstNames: array [0 .. 503] of String = ('��', 'Ǯ', '��', '��', '��', '��', '֣',
    '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    'ʩ', '��', '��', '��', '��', '��', '��', 'κ', '��', '��', '��', 'л', '��', '��', '��',
    'ˮ', '�', '��', '��', '��', '��', '��', '��', '��', '��', '��', '³', 'Τ', '��', '��',
    '��', '��', '��', '��', '��', '��', 'Ԭ', '��', 'ۺ', '��', 'ʷ', '��', '��', '��', '�',
    'Ѧ', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    'ʱ', '��', 'Ƥ', '��', '��', '��', '��', '��', 'Ԫ', '��', '��', '��', 'ƽ', '��', '��',
    '��', '��', '��', 'Ҧ', '��', '��', '��', '��', 'ë', '��', '��', '��', '��', '��', '�',
    '��', '��', '��', '��', '̸', '��', 'é', '��', '��', '��', '��', '��', '��', 'ף', '��',
    '��', '��', '��', '��', '��', 'ϯ', '��', '��', 'ǿ', '��', '·', '¦', 'Σ', '��', 'ͯ',
    '��', '��', '÷', 'ʢ', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', '֧', '��', '��', '��', '¬', 'Ī', '��', '��', '��', '��',
    '��', '��', 'Ӧ', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    'ʯ', '��', '��', 'ť', '��', '��', '��', '��', '��', '��', '½', '��', '��', '��', '��',
    '�', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', '��', '��', '��', '��', 'ɽ', '��', '��', '��', '�', '��',
    'ȫ', 'ۭ', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', '��', 'ղ', '��', '��', 'Ҷ', '��', '˾', '��', '۬', '��',
    '��', '��', 'ӡ', '��', '��', '��', '��', 'ۢ', '��', '��', '��', '��', '��', '��', '׿',
    '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '˫', '��', 'ݷ', '��', '��',
    '̷', '��', '��', '��', '��', '��', '��', '��', 'Ƚ', '��', '۪', 'Ӻ', '��', '�', 'ɣ',
    '��', '�', 'ţ', '��', 'ͨ', '��', '��', '��', '��', 'ۣ', '��', '��', 'ũ', '��', '��',
    'ׯ', '��', '��', '��', '��', '��', 'Ľ', '��', '��', 'ϰ', '��', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', '»', '��', '��', 'Ź', '�', '��', '��', 'ε', 'Խ', '��',
    '¡', 'ʦ', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    '��', '��', '��', '��', 'ɳ', 'ؿ', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', 'Ȩ', '��', '��', '��', '��', '��', '��ٹ', '˾��', '�Ϲ�',
    'ŷ��', '�ĺ�', '���', '����', '����', '����', '�ʸ�', 'ξ��', '����', '�̨', '��ұ', '����',
    '���', '����', '����', '̫��', '����', '����', '����', '��ԯ', '���', '����', '����', '����',
    'Ľ��', '����', '����', '˾ͽ', '˾��', '����', '˾��', '��', '��', '�ӳ�', '���', '��ľ', '����',
    '����', '���', '����', '����', '����', '�ذ�', '�й�', '�׸�', '����', '��', '��', '��', '��',
    '��', '۳', 'Ϳ', '��', '�θ�', '����', '����', '����', '����', '��', '��', '����', '΢��', '��',
    '˧', '��', '��', '��', '��', '��', '��', '����', '����', '����', '����', '��', 'Ĳ', '��',
    '٦', '��', '��', '�Ϲ�', 'ī', '��', '��', '��', '��', '��', '��', '١', '����',
    '��', '��');
var
  I, L: Integer;
begin
L := 1 + Random(2);
Result := '';
for I := 0 to L - 1 do
  Result := Result + WideChar($4E00 + Random(20902));
Result := FirstNames[Random(Length(FirstNames))] + Result;
end;

function CreateDemoDataSet(AOwner: TComponent; ARecordCount: Integer)
  : TQDataSet;
var
  AFdId, AFdAge, AFdBirthday, AFdName, AFdSex, AFdScale, AFdComment: TField;
  I: Integer;
begin
Result := TQDataSet.Create(AOwner);
Result.FieldDefs.Add('Id', ftString, 10);
Result.FieldDefs.Add('Age', ftInteger);
Result.FieldDefs.Add('Birthday', ftDateTime);
Result.FieldDefs.Add('Name', ftWideString, 30);
Result.FieldDefs.Add('Sex', ftBoolean);
Result.FieldDefs.Add('Scale', ftFloat);
Result.FieldDefs.Add('Comment', ftWideMemo);
Result.CreateDataSet;
Result.DisableControls;
try
  AFdId := Result.FieldByName('Id');
  AFdAge := Result.FieldByName('Age');
  AFdName := Result.FieldByName('Name');
  AFdSex := Result.FieldByName('Sex');
  AFdScale := Result.FieldByName('Scale');
  AFdBirthday := Result.FieldByName('Birthday');
  AFdComment := Result.FieldByName('Comment');
  for I := 1 to ARecordCount do
    begin
    Result.Append;
    AFdId.AsString := 'CC_' + IntToStr(I);
    AFdName.AsString := GetHumanName;
    AFdBirthday.AsDateTime := IncYear(IncDay(Now, -Random(50)),
      -Random(5));
    AFdAge.AsInteger := YearsBetween(Now, AFdBirthday.AsDateTime) + 1;
    AFdSex.AsBoolean := Random(10) > 5;
    AFdScale.AsFloat := Random(1000) / 10;
    AFdComment.AsString := 'Comment for ' + AFdName.AsString;
    Result.Post;
    end;
finally
  Result.EnableControls;
end;
end;
procedure TForm1.Button1Click(Sender: TObject);
begin
FDest.CopyFrom(FSource,dcmCurrents,Edit1.Text);
FDest.Distinct;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
  AField: TField;
begin
FSource := CreateDemoDataSet(Self, 100);
FDest := TQDataSet.Create(Self);
DataSource1.DataSet := FSource;
DataSource2.DataSet := FDest;
end;

end.
