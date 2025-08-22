import '../entities/character.dart';
import '../repositories/character_repository.dart';

/// Use case para buscar um personagem específico por ID
/// 
/// Encapsula a lógica de negócio para buscar detalhes de um personagem
class GetCharacterByIdUseCase {
  final CharacterRepository _repository;

  const GetCharacterByIdUseCase(this._repository);

  /// Executa o use case para buscar um personagem por ID
  /// 
  /// [id] - ID do personagem a ser buscado
  /// 
  /// Retorna um [Character] com os dados do personagem
  /// 
  /// Pode lançar exceções de rede que devem ser tratadas pela camada de apresentação
  Future<Character> call(int id) async {
    // Validação de entrada
    if (id <= 0) {
      throw ArgumentError('ID do personagem deve ser maior que 0');
    }

    // Executa a busca através do repository
    return await _repository.getCharacterById(id);
  }

  /// Método auxiliar para validar se um ID é válido
  /// 
  /// [id] - ID a ser validado
  /// 
  /// Retorna true se o ID é válido, false caso contrário
  bool isValidId(int id) {
    return id > 0;
  }
}