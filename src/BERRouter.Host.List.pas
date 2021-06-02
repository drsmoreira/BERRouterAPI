unit BERRouter.Host.List;

interface

uses
  System.JSON,
  System.Generics.Collections,
  BERRouter.Interfaces;

type

TBERRouterHostList = class(TInterfacedObject, iBERRouterHostList)

  private
    [weak]
    Fsubservice : iBERRouterSubService;
    FList : TList<iBERRouterHost>;
    procedure valid_host(aHost : iBERRouterHost);

  public
    constructor Create(aSubService : iBERRouterSubService);
    destructor Destroy; override;
    class function New(aSubService : iBERRouterSubService) : iBERRouterHostList;

    function count : integer;
    function add : iBERRouterHost;
    function post(aHost : iBERRouterHost) : iBERRouterHostList;
    function delete(index : integer) : iBERRouterHostList; overload;
    function delete(aHost : string; aPort : integer) : iBERRouterHostList; overload;
    function item(index : integer) : iBERRouterHost;
    function indexof(aHost : string; aPort : integer) : integer;
    function prior : iBERRouterHost;
    function last : iBERRouterHost;
    function toJSON : TJSONArray;
    function fromJSON(aValue : TJSONArray) : iBERRouterHostList;
    function &end : iBERRouterSubService;

end;

implementation

uses
  System.SysUtils,
  Exceptions.Types,
  BERRouter.Factory;

{ TBERRouterHostList }

constructor TBERRouterHostList.Create(aSubService : iBERRouterSubService);
begin
  FList := TList<iBERRouterHost>.Create;
  Fsubservice := aSubService;
end;
destructor TBERRouterHostList.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;
class function TBERRouterHostList.New(aSubService : iBERRouterSubService): iBERRouterHostList;
begin
  Result := TBERRouterHostList.Create(aSubService);
end;
function TBERRouterHostList.post(aHost: iBERRouterHost): iBERRouterHostList;
begin
  Result := Self;
  valid_host(aHost);
  FList.Add(aHost);
end;
function TBERRouterHostList.prior: iBERRouterHost;
begin
  if count = 0 then raise ENoHostFound.Create;
  Result := item(0);
end;
function TBERRouterHostList.fromJSON(aValue: TJSONArray): iBERRouterHostList;
var
  count : integer;
begin
  Result := Self;
  for count := 0 to Pred(aValue.Count) do
    begin
      add.fromJSON(aValue.Items[count] as TJSONObject)
         .post;
    end;
end;
function TBERRouterHostList.toJSON: TJSONArray;
var
  entity : iBERRouterHost;
begin
  Result := TJSONArray.Create;
  for entity in FList do
    Result.AddElement(entity.toJSON);
end;
procedure TBERRouterHostList.valid_host(aHost: iBERRouterHost);
var
  lHost : iBERRouterHost;
begin
  if FList.Count < 1 then exit;

  for lHost in FList do
    begin
      if (lHost.host = aHost.host) and (lHost.port = aHost.port) then
        raise EKeyViolation.Create;
    end;
end;
function TBERRouterHostList.&end: iBERRouterSubService;
begin
  Result := Fsubservice;
end;
function TBERRouterHostList.add : iBERRouterHost;
begin
  Result := TBERRouterFactory.New.host(Self);
end;
function TBERRouterHostList.count: integer;
begin
  Result := FList.Count;
end;
function TBERRouterHostList.delete(index: integer): iBERRouterHostList;
begin
  Result := Self;
  if index > Pred(FList.Count) then raise ENoHostFound.Create;
  FList.Delete(index);
end;
function TBERRouterHostList.delete(aHost: string; aPort: integer): iBERRouterHostList;
var
  lIndex : integer;
begin
  lIndex := indexof(aHost, aPort);
  if lIndex = -1 then raise ENoHostFound.Create;
  delete(lIndex);
end;
function TBERRouterHostList.indexof(aHost: string; aPort: integer): integer;
var
  count : integer;
  lHost : iBERRouterHost;
begin
  Result := -1;
  for count := 0 to Pred(FList.Count) do
    begin
      lHost := FList.Items[count];
      if (lHost.host = aHost) and (lHost.port = aPort) then
        begin
          Result := count;
          exit;
        end;
    end;
end;
function TBERRouterHostList.item(index: integer): iBERRouterHost;
begin
  if index > Pred(FList.Count) then raise ENoHostFound.Create;
  Result := FList.Items[index];
end;
function TBERRouterHostList.last: iBERRouterHost;
begin
  if count = 0 then raise ENoHostFound.Create;
  Result := item(Pred(count));
end;

end.
