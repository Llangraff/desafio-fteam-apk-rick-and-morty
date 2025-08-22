import '../models/character_model.dart';
import '../models/characters_response_model.dart';
import '../../domain/entities/character_filter_params.dart';

/// Contrato para fonte de dados remota de personagens
abstract class CharacterRemoteDataSource {
  /// Busca personagens com parâmetros opcionais de filtro e paginação
  ///
  /// [params] - Parâmetros de filtro e paginação. Se null, busca primeira página sem filtros.
  ///
  /// Unifica a busca simples e com filtros em um único método para consistência.
  Future<CharactersResponseModel> getCharacters([CharacterFilterParams? params]);

  /// Busca um personagem específico por ID
  ///
  /// [id] - ID do personagem
  Future<CharacterModel> getCharacterById(int id);

  /// Busca um personagem aleatório (Portal Aleatório)
  ///
  /// Gera um ID aleatório entre 1-826 e busca o personagem
  Future<CharacterModel> getRandomCharacter();
}