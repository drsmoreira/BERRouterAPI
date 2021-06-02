unit BERRouter;

interface

uses
  System.JSON,
  System.Generics.Collections,
  BERRouter.Interfaces,
  Component.DictionaryList;

type

TBERRouter = class(TInterfacedObject, iBERRouter)

  private
    fListService : TDictionaryList<string, iBERRouterService>;
    procedure validJSON(json : TJSONObject);

  public
    constructor Create;
    destructor Destroy; override;
    class function New : iBERRouter;

    function service(aService : string) : iBERRouterService;
    function del_service(aService : string) : iBERRouter;
    function host_default(aService, aSubservice : string) : iBERRouterHost; overload;
    function hosts(aService, aSubservice : string) : iBERRouterHostList; overload;
    function toJSON : TJSONObject;
    function fromJSON(json : TJSONObject) : iBERRouter;
    function save(afile : string = ''; aCrypt : boolean = True) : iBERRouter;
    function load(afile : string = ''; aCrypt : boolean = True) : iBERRouter;
end;

var
 BERRouterAPI : iBERRouter;

implementation

uses
  System.Classes,
  System.SysUtils,
  System.IOUtils,
  Exceptions.Types,
  LocalCache4D.Compression,
  BERRouter.Factory;

{ TBERRouter }

constructor TBERRouter.Create;
begin
  FListService := TDictionaryList<string, iBERRouterService>.Create;
end;
destructor TBERRouter.Destroy;
begin
  FreeAndNil(FListService);
  inherited;
end;
class function TBERRouter.New: iBERRouter;
begin
  Result := TBERRouter.Create;
end;
function TBERRouter.service(aService: string): iBERRouterService;
begin
  if not fListService.TryGetValue(aService, Result) then
    Result := TBERRouterFactory.New.service(Self)
                                   .service(aService);

  fListService.AddOrSetValue(aService, Result);
end;
function TBERRouter.del_service(aService: string): iBERRouter;
begin
  Result := Self;
  if aService = '' then exit;
  FListService.Remove(aService);
end;
function TBERRouter.host_default(aService, aSubservice: string): iBERRouterHost;
begin
  Result := hosts(aService, aSubservice).prior;
end;
function TBERRouter.hosts(aService, aSubservice: string): iBERRouterHostList;
begin
  Result := service(aService).subservice(aSubservice)
                             .hosts;
end;
function TBERRouter.fromJSON(json: TJSONObject): iBERRouter;
var
  fServices : TJSONArray;
  count : integer;
  fService : iBERRouterService;
begin
  Result := Self;
  fListService.Clear;
  validJSON(json);
  fServices := json.GetValue<TJSONArray>('services');
  for count := 0 to pred(fServices.Count) do
    begin
      fService := TBERRouterFactory.new.service(Self)
                                       .fromJSON(fServices.Items[count] as TJSONObject);
      fListService.Add(fService.service, fService);
    end;

  FreeAndNil(json);
end;
function TBERRouter.toJSON: TJSONObject;
var
  fService : iBERRouterService;
  fServices : TJSONArray;
begin
  fServices := TJSONArray.Create;

  for fService in fListService.lista_value do
    fServices.Add(fService.toJSON);

  Result := TJSONObject.Create;
  Result.AddPair('services', fServices);
end;
procedure TBERRouter.validJSON(json: TJSONObject);
begin
  if not Assigned(json.GetValue<TJSONArray>('services')) then
    raise EInvalidJSON.Create('Services');
end;
function TBERRouter.load(afile : string = ''; aCrypt : boolean = True) : iBERRouter;
var
  lFileName : string;
begin
  Result := Self;
  lFileName := afile;
  if afile = '' then
    lFileName := ChangeFileExt(ParamStr(0), '.ber');

  if not FileExists(lFileName) then
    raise Exception.Create('Arquivo : ' + lFileName + ' não encontrado!');

  if aCrypt then
    fromJSON(TJSONObject.ParseJSONValue(TLocalCache4DCompreesion.Decode(TFile.ReadAllText(lFileName))) as TJSONObject)
  else
    fromJSON(TJSONObject.ParseJSONValue(TFile.ReadAllText(lFileName)) as TJSONObject);
end;
function TBERRouter.save(afile : string = ''; aCrypt : boolean = True) : iBERRouter;
var
  lFileName : string;
  lFile : TStringList;
  ljson : TJSONObject;
begin
  Result := Self;

  ljson := toJSON;

  lFileName := afile;
  if afile = '' then
    lFileName := ChangeFileExt(ParamStr(0), '.ber');

  if FileExists(lFileName) then
    DeleteFile(lFileName);

  try
    lFile := TStringList.Create;
    if aCrypt then
      lFile.Add(TLocalCache4DCompreesion.Encode(ljson.ToString))
    else
      lFile.Add(ljson.ToString);
    lFile.SaveToFile(lFileName, TEncoding.Unicode);
  finally
    FreeAndNil(lFile);
    FreeAndNil(ljson);
  end;
end;



initialization
  BERRouterAPI := TBERRouter.New;

end.
