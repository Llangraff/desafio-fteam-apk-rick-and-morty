import '../entities/character.dart';
import '../entities/characters_page.dart';
import '../entities/character_filter_params.dart';

/// Contrato do repositório de personagens
///
/// Define as operações de domínio para acessar dados de personagens
abstract class CharacterRepository {
  /// Busca personagens com parâmetros opcionais de filtro e paginação
  ///
  /// [params] - Parâmetros de filtro e paginação. Se null, busca primeira página sem filtros.
  ///
  /// Retorna um [CharactersPage] contendo a lista de personagens e informações de paginação.
  /// Unifica a busca simples e com filtros em um único método para consistência.
  Future<CharactersPage> getCharacters([CharacterFilterParams? params]);

  /// Busca um personagem específico por ID
  ///
  /// [id] - ID do personagem
  ///
  /// Retorna um [Character] com os dados do personagem
  Future<Character> getCharacterById(int id);

  /// Busca um personagem aleatório da base de dados (Portal Aleatório)
  ///
  /// Gera um ID aleatório entre 1-826 (total de personagens na API)
  /// e busca o personagem correspondente
  ///
  /// Retorna um [Character] aleatório
  Future<Character> getRandomCharacter();
}