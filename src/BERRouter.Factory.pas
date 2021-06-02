unit BERRouter.Factory;

interface

uses
  BERRouter.Interfaces;

type

TBERRouterFactory = class(TInterfacedObject, iBERRouterFactory)

  private

  public
    constructor Create;
    destructor Destroy; override;
    class function New : iBERRouterFactory;

    function host(aList : iBERRouterHostList) : iBERRouterHost;
    function list_host(aSubservice : iBERRouterSubService) : iBERRouterHostList;
    function subservice(aService : iBERRouterService) : iBERRouterSubService;
    function service(aBERRouter : iBERRouter) : iBERRouterService;

end;

implementation

uses
  BERRouter.Service,
  BERRouter.Host.List,
  BERRouter.Host,
  BERRouter.SubService;

{ TBERRouterFactory }

constructor TBERRouterFactory.Create;
begin

end;
destructor TBERRouterFactory.Destroy;
begin

  inherited;
end;
class function TBERRouterFactory.New: iBERRouterFactory;
begin
  Result := TBERRouterFactory.Create;
end;
function TBERRouterFactory.subservice(aService: iBERRouterService): iBERRouterSubService;
begin
  Result := TBERRouterSubService.New(aService);
end;
function TBERRouterFactory.host(aList: iBERRouterHostList): iBERRouterHost;
begin
  Result := TBERRouterHost.New(aList);
end;
function TBERRouterFactory.list_host(aSubService: iBERRouterSubService): iBERRouterHostList;
begin
  Result := TBERRouterHostList.New(aSubService);
end;
function TBERRouterFactory.service(aBERRouter: iBERRouter): iBERRouterService;
begin
  Result := TBERRouterService.New(aBERRouter);
end;

end.
