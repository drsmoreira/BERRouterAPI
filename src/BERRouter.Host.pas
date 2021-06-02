unit BERRouter.Host;

interface

uses
  System.JSON,
  BERRouter.Interfaces;

type

TBERRouterHost = class(TInterfacedObject, iBERRouterHost)

  private
    [Weak]
    Fhostlist : iBERRouterHostList;
    Fhost : string;
    Fport : integer;
    Ftoken : string;
    procedure validJSON(aValue : TJSONObject);

  public
    constructor Create(ahostlist : iBERRouterHostList);
    destructor Destroy; override;
    class function New(ahostlist : iBERRouterHostList) : iBERRouterHost;

    function host : string; overload;
    function host(Value : string) : iBERRouterHost; overload;
    function port : integer; overload;
    function port(Value : integer) : iBERRouterHost; overload;
    function port(Value : string) : iBERRouterHost; overload;
    function token : string; overload;
    function token(Value : string) : iBERRouterHost; overload;
    function post : iBERRouterHost;

    function &end : iBERRouterHostList;
    function toJSON : TJSONObject;
    function fromJSON(aValue : TJSONObject) : iBERRouterHost;

end;

implementation

uses
  System.Classes,
  System.SysUtils,
  Exceptions.Types;

{ TBERRouterHost }

constructor TBERRouterHost.Create(ahostlist : iBERRouterHostList);
begin
  Fhostlist := ahostlist;
end;
destructor TBERRouterHost.Destroy;
begin

  inherited;
end;
class function TBERRouterHost.New(ahostlist : iBERRouterHostList): iBERRouterHost;
begin
  Result := TBERRouterHost.Create(ahostlist);
end;
function TBERRouterHost.port(Value: string): iBERRouterHost;
begin
  Result := Self;
  if (Value = '') then raise EFieldRequired.Create('Porta');
  port(StrToInt(Value));
end;
function TBERRouterHost.host: string;
begin
  Result := Fhost;
end;
function TBERRouterHost.host(Value: string): iBERRouterHost;
begin
  Result := Self;
  if Value = '' then raise EFieldRequired.Create('Host');
  Fhost := Value;
end;
function TBERRouterHost.port: integer;
begin
  Result := Fport;
end;
function TBERRouterHost.port(Value: integer): iBERRouterHost;
begin
  Result := Self;
  if Value <= 0 then raise EFieldRequired.Create('Port');
  Fport := Value;
end;
function TBERRouterHost.token: string;
begin
  Result := Ftoken;
end;
function TBERRouterHost.token(Value: string): iBERRouterHost;
begin
  Result := Self;
  Ftoken := Value;
end;
function TBERRouterHost.post: iBERRouterHost;
begin
  Result := Self;
  Fhostlist.post(Self);
end;
function TBERRouterHost.&end: iBERRouterHostList;
begin
  Result := Fhostlist;
end;
procedure TBERRouterHost.validJSON(aValue : TJSONObject);
begin
  if not Assigned(aValue.GetValue('host')) then raise EInvalidJSON.Create('host');
  if not Assigned(aValue.GetValue<TJSONNumber>('port')) then raise EInvalidJSON.Create('porta');
end;
function TBERRouterHost.fromJSON(aValue : TJSONObject) : iBERRouterHost;
begin
  Result := Self;
  validJSON(aValue);
  Fhost := aValue.GetValue('host').Value;
  Fport := aValue.GetValue<TJSONNumber>('port').AsInt;
  Ftoken := '';
  if Assigned(aValue.GetValue('token')) then
    Ftoken := aValue.GetValue('token').Value;
end;
function TBERRouterHost.toJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('host', Fhost);
  Result.AddPair('port', TJSONNumber.Create(Fport));
  Result.AddPair('token', Ftoken);
end;

end.
