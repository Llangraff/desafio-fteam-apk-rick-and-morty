import 'dart:math';
import '../../../../core/network/api_client.dart';
import '../models/character_model.dart';
import '../models/characters_response_model.dart';
import '../../domain/entities/character_filter_params.dart';
import 'character_remote_data_source.dart';

/// Implementação concreta da fonte de dados remota de personagens
class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final ApiClient _apiClient;

  const CharacterRemoteDataSourceImpl(this._apiClient);

  @override
  Future<CharactersResponseModel> getCharacters([CharacterFilterParams? params]) async {
    // Se não há parâmetros, usa configuração padrão (primeira página, sem filtros)
    final filterParams = params ?? const CharacterFilterParams.empty();
    
    // Converte os parâmetros para query parameters da API
    final queryParameters = filterParams.toQueryParameters();
    
    // Constrói a URL com os parâmetros
    final queryString = queryParameters.entries
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
        .join('&');
    
    final url = queryString.isNotEmpty
        ? '/character?$queryString'
        : '/character?page=1';
    
    final response = await _apiClient.get(url);
    return CharactersResponseModel.fromJson(response);
  }

  @override
  Future<CharacterModel> getCharacterById(int id) async {
    final response = await _apiClient.get('/character/$id');
    return CharacterModel.fromJson(response);
  }

  @override
  Future<CharacterModel> getRandomCharacter() async {
    // Gera ID aleatório entre 1-826 (total de personagens na API Rick & Morty)
    final random = Random();
    final randomId = random.nextInt(826) + 1;
    
    // Reutiliza o método existente para buscar por ID
    return await getCharacterById(randomId);
  }
}