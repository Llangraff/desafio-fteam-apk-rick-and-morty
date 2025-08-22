import '../entities/character.dart';
import '../repositories/character_repository.dart';

/// Use case para buscar um personagem aleatório (Portal Aleatório)
///
/// Encapsula a lógica de negócio para a funcionalidade "Random Portal"
/// inspirada na Portal Gun do Rick and Morty
class GetRandomCharacterUseCase {
  final CharacterRepository _repository;

  const GetRandomCharacterUseCase(this._repository);

  /// Executa o Portal Aleatório
  ///
  /// Busca um personagem completamente aleatório dentre os 826 disponíveis na API
  ///
  /// Retorna um [Character] aleatório
  ///
  /// Pode lançar exceções de rede que devem ser tratadas pela camada de apresentação
  Future<Character> call() async {
    return await _repository.getRandomCharacter();
  }

  /// Executa múltiplos portais aleatórios (para futuras funcionalidades)
  ///
  /// [count] - Número de personagens aleatórios para buscar
  ///
  /// Retorna uma lista de [Character] aleatórios únicos
  ///
  /// **Nota**: Método preparado para futuras funcionalidades como "Portal Storm"
  Future<List<Character>> callMultiple(int count) async {
    final characters = <Character>[];
    final usedIds = <int>{};
    
    for (int i = 0; i < count; i++) {
      Character character;
      do {
        character = await _repository.getRandomCharacter();
      } while (usedIds.contains(character.id) && usedIds.length < 826);
      
      usedIds.add(character.id);
      characters.add(character);
    }
    
    return characters;
  }
}