import '../../domain/entities/character.dart';
import '../../domain/entities/characters_page.dart';
import '../../domain/entities/character_filter_params.dart';
import '../../domain/repositories/character_repository.dart';
import '../sources/character_remote_data_source.dart';
import '../mappers/character_mapper.dart';

/// Implementação concreta do repositório de personagens
///
/// Atua como intermediário entre a camada de domínio e a fonte de dados remota,
/// convertendo modelos de dados em entidades de domínio
class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource _remoteDataSource;

  const CharacterRepositoryImpl(this._remoteDataSource);

  @override
  Future<CharactersPage> getCharacters([CharacterFilterParams? params]) async {
    try {
      final response = await _remoteDataSource.getCharacters(params);
      return response.toDomain();
    } catch (e) {
      // Relança a exceção para que seja tratada na camada superior
      rethrow;
    }
  }

  @override
  Future<Character> getCharacterById(int id) async {
    try {
      final character = await _remoteDataSource.getCharacterById(id);
      return character.toDomain();
    } catch (e) {
      // Relança a exceção para que seja tratada na camada superior
      rethrow;
    }
  }

  @override
  Future<Character> getRandomCharacter() async {
    try {
      final character = await _remoteDataSource.getRandomCharacter();
      return character.toDomain();
    } catch (e) {
      // Relança a exceção para que seja tratada na camada superior
      rethrow;
    }
  }
}