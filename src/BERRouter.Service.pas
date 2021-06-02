unit BERRouter.Service;

interface

uses
  System.JSON,
  Component.DictionaryList,
  BERRouter.Interfaces;

type

TBERRouterService = class(TInterfacedObject, iBERRouterService)

  private
    [weak]
    FRouter : iBERRouter;
    Fservice : string;
    FList : TDictionaryList<string, iBERRouterSubService>;
    procedure validJson(aValue : TJSONObject);

  public
    constructor Create(router : iBERRouter);
    destructor Destroy; override;
    class function New(router : iBERRouter) : iBERRouterService;

    function service : string; overload;
    function service(Value : string) : iBERRouterService; overload;
    function subservice(aSubservice : string) : iBERRouterSubService;
    function del_subservice(aSubservice : string) : iBERRouterService;

    function &End : iBERRouter;
    function toJSON : TJSONObject;
    function fromJSON(aValue : TJSONObject) : iBERRouterService;

end;

implementation

uses
  System.SysUtils,
  Exceptions.Types,
  BERRouter.Factory;

{ TBERRouterService }

constructor TBERRouterService.Create(router: iBERRouter);
begin
  FRouter := router;
  Fservice := '';
  FList := TDictionaryList<string, iBERRouterSubService>.Create;
end;
destructor TBERRouterService.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;
class function TBERRouterService.New(router: iBERRouter): iBERRouterService;
begin
  Result := TBERRouterService.Create(router);
end;
function TBERRouterService.service: string;
begin
  Result := Fservice;
end;
function TBERRouterService.service(Value: string): iBERRouterService;
begin
  Result := Self;
  Fservice := Value;
end;
function TBERRouterService.subservice(aSubservice: string): iBERRouterSubService;
begin
  if not FList.TryGetValue(aSubservice, Result) then
    Result := TBERRouterFactory.New.subservice(Self)
                                   .subservice(aSubservice);

  FList.AddOrSetValue(aSubservice, Result);
end;
function TBERRouterService.del_subservice(aSubservice: string): iBERRouterService;
var
  lSubService : iBERRouterSubService;
begin
  Result := Self;
  if aSubservice = '' then
    raise EFieldRequired.Create(aSubservice);

  if not FList.TryGetValue(aSubservice, lSubService) then
    raise ENoSubServiceFound.Create;

  FList.Remove(aSubservice);
end;
function TBERRouterService.toJSON: TJSONObject;
var
  fsubservices : iBERRouterSubService;
  json_subservice : TJSONArray;
begin
  json_subservice := TJSONArray.Create;

  for fsubservices in FList.lista_value do
    json_subservice.AddElement(fsubservices.toJSON);

  Result := TJSONObject.Create;
  Result.AddPair('service', Fservice);
  Result.AddPair('subservices', json_subservice);
end;
procedure TBERRouterService.validJson(aValue: TJSONObject);
begin
  if not Assigned(aValue.GetValue('service')) then raise ENoValidToken.Create('service');
  if not Assigned(aValue.GetValue<TJSONArray>('subservices')) then raise ENoValidToken.Create('subservices');
end;
function TBERRouterService.fromJSON(aValue: TJSONObject): iBERRouterService;
var
  json_subservices : TJSONArray;
  json_subservice : TJSONValue;
  fsubservice : iBERRouterSubService;
begin
  Result := Self;
  validJson(aValue);
  FList.Clear;

  Fservice := aValue.GetValue('service').Value;
  json_subservices := aValue.GetValue<TJSONArray>('subservices') as TJSONArray;
  for json_subservice in json_subservices do
    begin
      fsubservice := TBERRouterFactory.New.subservice(Self)
                                          .fromJSON(json_subservice as TJSONObject);

      FList.Add(fsubservice.subservice, fsubservice);
    end;
end;
function TBERRouterService.&End: iBERRouter;
begin
  Result := FRouter;
end;

end.
