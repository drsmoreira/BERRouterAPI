unit BERRouter.SubService;

interface

uses
  System.JSON,
  BERRouter.Interfaces;

type

TBERRouterSubService = class(TInterfacedObject, iBERRouterSubService)

  private
    [Weak]
    Fservice : iBERRouterService;
    Fhosts : iBERRouterHostList;
    FSubService : string;
    procedure validJSON(aValue : TJSONObject);

  public
    constructor Create(service : iBERRouterService);
    destructor Destroy; override;
    class function New(service : iBERRouterService) : iBERRouterSubService;

    function subservice : string; overload;
    function subservice(Value : string) : iBERRouterSubService; overload;
    function hosts : iBERRouterHostList;
    function toJSON : TJSONObject;
    function fromJSON(aValue : TJSONObject) : iBERRouterSubService;
    function &End : iBERRouterService;

end;

implementation

uses
  Exceptions.Types,
  BERRouter.Factory, System.SysUtils;

{ TBERRouterSubService }

constructor TBERRouterSubService.Create(service: iBERRouterService);
begin
  Fservice := service;
  Fhosts := TBERRouterFactory.New.list_host(Self);
end;
destructor TBERRouterSubService.Destroy;
begin

  inherited;
end;
class function TBERRouterSubService.New(service: iBERRouterService): iBERRouterSubService;
begin
  Result := TBERRouterSubService.Create(service);
end;
function TBERRouterSubService.&End: iBERRouterService;
begin
  Result := Fservice;
end;
function TBERRouterSubService.subservice: string;
begin
  Result := FSubService;
end;
function TBERRouterSubService.subservice(Value: string): iBERRouterSubService;
begin
  Result := Self;
  FSubService := Value;
end;
function TBERRouterSubService.hosts: iBERRouterHostList;
begin
  Result := Fhosts;
end;
function TBERRouterSubService.toJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('subservice', FSubService);
  Result.AddPair('hosts', Fhosts.toJSON);
end;
procedure TBERRouterSubService.validJSON(aValue : TJSONObject);
begin
  if not Assigned(aValue.GetValue('subservice')) then raise EInvalidJSON.Create('subservice');
  if not Assigned(aValue.GetValue<TJSONArray>('hosts')) then raise EInvalidJSON.Create('hosts')
end;
function TBERRouterSubService.fromJSON(aValue: TJSONObject): iBERRouterSubService;
begin
  Result := Self;
  validJSON(aValue);
  FSubService := aValue.GetValue('subservice').Value;
  Fhosts.fromJSON(aValue.GetValue<TJSONArray>('hosts') as TJSONArray);
end;

end.
