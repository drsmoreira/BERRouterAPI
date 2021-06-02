unit BERRouter.Interfaces;

interface

uses
  System.Generics.Collections,
  System.JSON;

type

iBERRouter = interface;

iBERRouterService = interface;

iBERRouterSubService = interface;

iBERRouterHostList = interface;

iBERRouterHost = interface
  ['{78607E01-996B-4839-9D7A-E02FF6000E4B}']

  function host : string; overload;
  function host(Value : string) : iBERRouterHost; overload;
  function port : integer; overload;
  function port(Value : integer) : iBERRouterHost; overload;
  function token : string; overload;
  function token(Value : string) : iBERRouterHost; overload;
  function post : iBERRouterHost;
  function &end : iBERRouterHostList;
  function toJSON : TJSONObject;
  function fromJSON(aValue : TJSONObject) : iBERRouterHost;

end;

iBERRouterHostList = interface
  ['{42185C9B-71B8-4940-94C9-949A87019DA7}']
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

iBERRouterSubService = interface
  ['{F272A5D8-43F1-4B75-BD0C-845F02987409}']
  function subservice : string; overload;
  function subservice(Value : string) : iBERRouterSubService; overload;
  function hosts : iBERRouterHostList;
  function toJSON : TJSONObject;
  function fromJSON(aValue : TJSONObject) : iBERRouterSubService;
  function &End : iBERRouterService;

end;

iBERRouterService = interface
  ['{206210FF-DA8B-4749-AF07-C4A81D2EBDAE}']

  function service : string; overload;
  function service(Value : string) : iBERRouterService; overload;
  function subservice(aSubservice : string) : iBERRouterSubService;
  function del_subservice(aSubservice : string) : iBERRouterService;

  function &End : iBERRouter;
  function toJSON : TJSONObject;
  function fromJSON(aValue : TJSONObject) : iBERRouterService;

end;

iBERRouter = interface
  ['{56BC9157-9589-4D9C-B0DF-5C9DD4DDCA83}']

  function service(aService : string) : iBERRouterService;
  function del_service(aService : string) : iBERRouter;
  function host_default(aService, aSubservice : string) : iBERRouterHost; overload;
  function hosts(aService, aSubservice : string) : iBERRouterHostList; overload;
  function toJSON : TJSONObject;
  function fromJSON(json : TJSONObject) : iBERRouter;
  function save(afile : string = ''; aCrypt : boolean = True) : iBERRouter;
  function load(afile : string = ''; aCrypt : boolean = True) : iBERRouter;

end;

iBERRouterFactory = interface
  ['{DFA85FB9-593C-41A7-B10E-0F4C2D74EB4B}']

  function host(aList : iBERRouterHostList) : iBERRouterHost;
  function list_host(aSubservice : iBERRouterSubService) : iBERRouterHostList;
  function subservice(aService : iBERRouterService) : iBERRouterSubService;
  function service(aBERRouter : iBERRouter) : iBERRouterService;

end;

implementation

end.
