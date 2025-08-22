import '../entities/characters_page.dart';
import '../entities/character_filter_params.dart';
import '../repositories/character_repository.dart';

/// Use case para buscar uma página de personagens
///
/// Encapsula a lógica de negócio para buscar personagens com paginação e filtros
class GetCharactersPageUseCase {
  final CharacterRepository _repository;

  const GetCharactersPageUseCase(this._repository);

  /// Executa o use case para buscar personagens
  ///
  /// [params] - Parâmetros de filtro e paginação. Se null, busca primeira página sem filtros.
  ///
  /// Retorna um [CharactersPage] contendo a lista de personagens e informações de paginação
  ///
  /// Pode lançar exceções de rede que devem ser tratadas pela camada de apresentação
  Future<CharactersPage> call([CharacterFilterParams? params]) async {
    // Se há parâmetros, valida página
    if (params != null && params.page < 1) {
      throw ArgumentError('Número da página deve ser maior que 0');
    }

    // Executa a busca através do repository
    return await _repository.getCharacters(params);
  }

  /// Método auxiliar para buscar apenas por página (compatibilidade)
  ///
  /// [page] - Número da página a ser buscada (padrão: 1)
  Future<CharactersPage> callByPage({int page = 1}) async {
    return await call(CharacterFilterParams.pageOnly(page));
  }

  /// Método auxiliar para buscar com filtros específicos
  ///
  /// [name] - Nome do personagem para busca
  /// [status] - Lista de status do personagem
  /// [species] - Lista de espécies do personagem
  /// [type] - Lista de tipos do personagem
  /// [gender] - Lista de gêneros do personagem
  /// [page] - Número da página para paginação de resultados filtrados
  Future<CharactersPage> callWithFilters({
    String? name,
    List<String>? status,
    List<String>? species,
    List<String>? type,
    List<String>? gender,
    int page = 1,
  }) async {
    final params = CharacterFilterParams(
      name: name,
      status: status,
      species: species,
      type: type,
      gender: gender,
      page: page,
    );

    return await call(params);
  }

  /// Método auxiliar para buscar a próxima página mantendo os mesmos filtros
  ///
  /// [currentPage] - Página atual com informações de paginação
  /// [currentParams] - Parâmetros atuais de filtro
  ///
  /// Retorna null se não houver próxima página disponível
  Future<CharactersPage?> getNextPage(
    CharactersPage currentPage,
    [CharacterFilterParams? currentParams]
  ) async {
    if (!currentPage.canLoadMore) {
      return null;
    }

    final nextPageNumber = currentPage.nextPage;
    if (nextPageNumber == null) {
      return null;
    }

    // Mantém os filtros atuais e muda apenas a página
    final nextPageParams = currentParams?.copyWithPage(nextPageNumber)
                          ?? CharacterFilterParams.pageOnly(nextPageNumber);

    return await call(nextPageParams);
  }
}