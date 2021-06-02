unit Component.DictionaryList;

interface

uses
  Generics.Collections;

type

TDictionaryList<TKey,TValue> = class(TDictionary<TKey,TValue>)

  private
    Flista_key: TList<TKey>;
    Flista_value: TList<TValue>;
    Fkey_default: TKey;
    function GetValue(const Value: TValue): TKey;
    procedure SetValue(const Value: TValue; const Key: TKey);

  public
    constructor Create(ACapacity: Integer = 0); overload;
    destructor Destroy; override;

    procedure Add(const Key: TKey; const Value: TValue); reintroduce;
    procedure AddOrSetValue(const Key: TKey; const Value: TValue); reintroduce;
    procedure Remove(const Key: TKey); reintroduce;
    procedure Clear; reintroduce;

    property Value[const Value: TValue]: TKey read GetValue write SetValue;
    property lista_key : TList<TKey> read Flista_key write Flista_key;
    property lista_value : TList<Tvalue> read Flista_value write Flista_value;
    property key_default : TKey read Fkey_default write Fkey_default;
end;


implementation

uses
  SysUtils, Classes, Generics.Defaults, RTLConsts;

{ TDictionaryList<TKey, TValue> }

constructor TDictionaryList<TKey, TValue>.Create(ACapacity: Integer);
begin
  inherited;
  Flista_key   := TList<TKey>.Create;
  Flista_value := TList<TValue>.Create;
end;
destructor TDictionaryList<TKey, TValue>.Destroy;
begin
{  while Flista_key.Count > 0 do Remove(Flista_key.Items[0]);
  Flista_key.Clear;
  Flista_value.Clear;}
  Flista_key.Free;
  Flista_value.Free;
  inherited;
end;
procedure TDictionaryList<TKey, TValue>.Add(const Key: TKey; const Value: TValue);
begin
  inherited Add(Key, Value);
  Flista_key  .Add(Key);
  Flista_value.Add(Value);
end;
function TDictionaryList<TKey, TValue>.GetValue(const Value: TValue): TKey;
var
  index : integer;
begin
  index := Flista_value.IndexOf(Value);
  if index = -1 then raise EListError.CreateRes(@SGenericItemNotFound);
  Result := Flista_key.Items[index];
end;
procedure TDictionaryList<TKey, TValue>.Remove(const Key: TKey);
var
  Valor : TValue;
begin
  Flista_key.Remove(Key);
  if TryGetValue(Key, Valor) then Flista_value.Remove(Valor);
  inherited Remove(Key);
end;
procedure TDictionaryList<TKey, TValue>.SetValue(const Value: TValue; const Key: TKey);
begin
  AddOrSetValue(Key, Value);
end;
procedure TDictionaryList<TKey, TValue>.AddOrSetValue(const Key: TKey; const Value: TValue);
begin
  inherited AddOrSetValue(Key, Value);

  if Flista_key.IndexOf(Key) = -1 then
    begin
      Flista_key.Add(Key);
      Flista_value.Add(Value);
      exit;
    end;
  Flista_value.Items[Flista_key.IndexOf(Key)] := Value;
end;
procedure TDictionaryList<TKey, TValue>.Clear;
begin
  inherited Clear;
  Flista_key.Clear;
  Flista_value.Clear;
end;

end.
