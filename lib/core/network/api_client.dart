import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'exceptions.dart';

/// Cliente HTTP configurado para consumir a API do Rick and Morty
class ApiClient {
  static const String _baseUrl = 'https://rickandmortyapi.com/api';
  static const Duration _timeout = Duration(seconds: 30);
  
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Realiza uma requisição GET
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      
      final response = await _client.get(
        uri,
        headers: _getHeaders(),
      ).timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw const NoConnectionException();
    } on HttpException catch (e) {
      throw ServerException(e.message);
    } on FormatException {
      throw const ParseException();
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  /// Configura os headers padrão para as requisições
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// Trata a resposta HTTP e mapeia erros para exceções customizadas
  Map<String, dynamic> _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return _parseJson(response.body);
      case 400:
        throw ClientException(
          'Requisição inválida',
          response.statusCode,
        );
      case 401:
        throw ClientException(
          'Não autorizado',
          response.statusCode,
        );
      case 403:
        throw ClientException(
          'Acesso negado',
          response.statusCode,
        );
      case 404:
        throw ClientException(
          'Recurso não encontrado',
          response.statusCode,
        );
      case 429:
        throw ClientException(
          'Muitas requisições. Tente novamente mais tarde.',
          response.statusCode,
        );
      case 500:
      case 502:
      case 503:
      case 504:
        throw ServerException(
          'Erro no servidor. Tente novamente mais tarde.',
          response.statusCode,
        );
      default:
        throw UnknownException(
          'Erro HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
    }
  }

  /// Faz parse do JSON de forma segura
  Map<String, dynamic> _parseJson(String body) {
    try {
      final decoded = json.decode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else {
        throw const ParseException('Resposta não é um objeto JSON válido');
      }
    } catch (e) {
      throw const ParseException('Erro ao decodificar JSON');
    }
  }

  /// Libera os recursos do cliente
  void dispose() {
    _client.close();
  }
}