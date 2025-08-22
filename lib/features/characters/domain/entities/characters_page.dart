import 'character.dart';
import 'page_info.dart';

/// Entidade que representa uma página de personagens com informações de paginação
/// 
/// Esta é a representação de domínio para o resultado paginado de personagens
class CharactersPage {
  final PageInfo info;
  final List<Character> characters;

  const CharactersPage({
    required this.info,
    required this.characters,
  });

  /// Verifica se a página está vazia
  bool get isEmpty => characters.isEmpty;

  /// Verifica se a página contém dados
  bool get isNotEmpty => characters.isNotEmpty;

  /// Obtém o total de personagens
  int get totalCharacters => info.count;

  /// Obtém o total de páginas disponíveis
  int get totalPages => info.pages;

  /// Verifica se pode carregar mais páginas
  bool get canLoadMore => info.hasNext;

  /// Obtém o número da próxima página para carregamento
  int? get nextPage => info.nextPageNumber;

  /// Cria uma nova página combinando com outra (usado para paginação infinita)
  CharactersPage combineWith(CharactersPage other) {
    return CharactersPage(
      info: other.info, // Usa as informações de paginação mais recentes
      characters: [...characters, ...other.characters], // Combina as listas
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CharactersPage &&
        other.info == info &&
        other.characters.length == characters.length &&
        other.characters.every((element) => characters.contains(element));
  }

  @override
  int get hashCode {
    return Object.hash(info, Object.hashAll(characters));
  }

  @override
  String toString() {
    return 'CharactersPage(totalCharacters: $totalCharacters, currentPageSize: ${characters.length}, canLoadMore: $canLoadMore)';
  }
}