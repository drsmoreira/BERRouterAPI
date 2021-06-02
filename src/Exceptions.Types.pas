unit Exceptions.Types;

interface

uses
  System.SysUtils;

type

EKeyViolation = class (Exception)

  public
    constructor Create(const msg : string); reintroduce; overload;
    constructor Create; reintroduce; overload;

end;
EFieldRequired = class(Exception)
  public
    constructor Create(const field: string); reintroduce;
end;
EFieldMaxLength = class(Exception)

  public
    constructor Create(const field: string; length : integer); reintroduce;

end;
ENoRecordFound = class(Exception)
  public
    constructor Create(const nome_entidade: string); reintroduce;
end;
ENoHostFound = class(Exception)
  public
    constructor Create;
end;
ENoSubServiceFound = class(Exception)
  public
    constructor Create;
end;
ENoServiceFound = class(Exception)
  public
    constructor Create;
end;
EInvalidJSON = class(Exception)
  public
    constructor Create(const campo: string); reintroduce;
end;
ENoValidToken = class(Exception)
  public
    constructor Create(const msg: string); reintroduce;
end;
ENoServerFound = class(Exception)
  public
    constructor Create; reintroduce;
end;
EBadRequest = class(Exception)
  public
    constructor Create(Content : string); reintroduce;
end;
ENoValidKey = class(Exception)
  public
    constructor Create; reintroduce;
end;
EInvalidRange = class(Exception)
  public
    constructor Create(inicio : integer; campo : string; fim : integer); reintroduce; overload;
    constructor Create(inicio : integer; campo : string); reintroduce; overload;
    constructor Create(campo : string; fim : integer); reintroduce; overload;

end;

implementation

{ EFieldRequired }

constructor EFieldRequired.Create(const field: string);
begin
  inherited Create('Campo ' + field + ' n�o informado!');
end;

{ EFieldMaxLength }

constructor EFieldMaxLength.Create(const field: string; length: integer);
begin
  inherited Create('Campo ' + field + ' informado como tamanho maior que ' + length.ToString);
end;

{ ENoRecordFound }

constructor ENoRecordFound.Create(const nome_entidade: string);
begin
  inherited Create(nome_entidade + ' n�o encontrado');
end;

{ EInvalidJSON }

constructor EInvalidJSON.Create(const campo: string);
begin
  inherited Create('JSON inv�lido!' + sLineBreak + 'Campo ' + campo + ' n�o localizado!');
end;

{ EKeyViolation }

constructor EKeyViolation.Create(const msg : string);
begin
  inherited Create('Registro Duplicado : ' + msg);
end;
constructor EKeyViolation.Create;
begin
  inherited Create('Registro Duplicado');
end;

{ ENoValidToken }

constructor ENoValidToken.Create(const msg: string);
var
  mensagem : string;
begin
  mensagem := msg;
  if mensagem = '' then mensagem := 'Tempo de Sess�o Expirado! Fa�a novo login para continuar';
  inherited Create(mensagem);
end;

{ ENoServerFound }

constructor ENoServerFound.Create;
begin
  inherited Create('Servidor n�o localizado ou offline');
end;

{ EBadRequest }

constructor EBadRequest.Create(Content : string);
begin
  inherited Create(Content);
end;

{ ENoValidKey }

constructor ENoValidKey.Create;
begin
  inherited Create('Chave inv�lida!');
end;

{ ENoHostFound }
constructor ENoHostFound.Create;
begin
  inherited Create('Host n�o localizada');
end;

{ ENoSubServiceFound }
constructor ENoSubServiceFound.Create;
begin
  inherited Create('Sub Servi�o n�o localizado');
end;

{ ENoServiceFound }
constructor ENoServiceFound.Create;
begin
  inherited Create('Servi�o n�o localizado');
end;

{ EInvalidRange }

constructor EInvalidRange.Create(inicio: integer; campo: string; fim: integer);
begin
  inherited Create('Campo ' + campo + ' com valor inv�lido.' + sLineBreak + 'Somente aceito n�meros entre (' + inicio.ToString + ' e ' + fim.ToString + ')');
end;
constructor EInvalidRange.Create(inicio: integer; campo: string);
begin
  inherited Create('Campo ' + campo + ' com valor inv�lido.' + sLineBreak + 'Somente aceito n�meros iguais ou acima de ' + inicio.ToString);
end;
constructor EInvalidRange.Create(campo: string; fim: integer);
begin
  inherited Create('Campo ' + campo + ' com valor inv�lido.' + sLineBreak + 'Somente aceito n�meros iguais ou abaixo de ' + fim.ToString);
end;

end.
