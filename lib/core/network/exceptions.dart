/// Exceções customizadas para tratamento de erros de rede
abstract class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException(this.message, [this.statusCode]);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exceção para erros de servidor (5xx)
class ServerException extends NetworkException {
  const ServerException([String? message, int? statusCode]) 
      : super(message ?? 'Erro interno do servidor', statusCode);
}

/// Exceção para erros de cliente (4xx)
class ClientException extends NetworkException {
  const ClientException([String? message, int? statusCode]) 
      : super(message ?? 'Erro na requisição', statusCode);
}

/// Exceção para timeout de conexão
class TimeoutException extends NetworkException {
  const TimeoutException([String? message]) 
      : super(message ?? 'Tempo limite de conexão excedido');
}

/// Exceção para falta de conexão com internet
class NoConnectionException extends NetworkException {
  const NoConnectionException([String? message]) 
      : super(message ?? 'Sem conexão com a internet');
}

/// Exceção para erros de parsing JSON
class ParseException extends NetworkException {
  const ParseException([String? message]) 
      : super(message ?? 'Erro ao processar dados do servidor');
}

/// Exceção genérica para erros não tratados
class UnknownException extends NetworkException {
  const UnknownException([String? message]) 
      : super(message ?? 'Erro desconhecido');
}