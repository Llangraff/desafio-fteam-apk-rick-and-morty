import '../../domain/entities/character.dart';
import '../../domain/entities/characters_page.dart';

/// Estados possíveis para a lista de personagens
abstract class CharacterListState {}

/// Estado inicial - sem dados carregados
class CharacterListInitial extends CharacterListState {}

/// Estado de carregamento da primeira página
class CharacterListLoading extends CharacterListState {}

/// Estado de carregamento de mais páginas (paginação infinita)
class CharacterListLoadingMore extends CharacterListState {
  final List<Character> currentCharacters;

  CharacterListLoadingMore(this.currentCharacters);
}

/// Estado de carregamento de filtros (consulta API com parâmetros)
class CharacterListLoadingFilter extends CharacterListState {}

/// Estado de resultados filtrados (busca completa na API)
class CharacterListFilterResults extends CharacterListState {
  final List<Character> characters;
  final bool hasMorePages;
  final int currentPage;
  final int totalPages;
  final String appliedFilters; // Descrição dos filtros aplicados

  CharacterListFilterResults({
    required this.characters,
    required this.hasMorePages,
    required this.currentPage,
    required this.totalPages,
    required this.appliedFilters,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CharacterListFilterResults &&
        other.characters.length == characters.length &&
        other.hasMorePages == hasMorePages &&
        other.currentPage == currentPage &&
        other.totalPages == totalPages &&
        other.appliedFilters == appliedFilters;
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(characters),
      hasMorePages,
      currentPage,
      totalPages,
      appliedFilters,
    );
  }
}

/// Estado de sucesso com dados
class CharacterListLoaded extends CharacterListState {
  final List<Character> characters;
  final bool canLoadMore;
  final int currentPage;
  final int totalPages;

  CharacterListLoaded({
    required this.characters,
    required this.canLoadMore,
    required this.currentPage,
    required this.totalPages,
  });

  /// Cria um novo estado com personagens adicionais (para paginação)
  CharacterListLoaded copyWithMoreCharacters(CharactersPage newPage) {
    return CharacterListLoaded(
      characters: [...characters, ...newPage.characters],
      canLoadMore: newPage.canLoadMore,
      currentPage: currentPage + 1,
      totalPages: newPage.totalPages,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CharacterListLoaded &&
        other.characters.length == characters.length &&
        other.canLoadMore == canLoadMore &&
        other.currentPage == currentPage &&
        other.totalPages == totalPages;
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(characters),
      canLoadMore,
      currentPage,
      totalPages,
    );
  }
}

/// Estado de lista vazia
class CharacterListEmpty extends CharacterListState {}

/// Estado de erro
class CharacterListError extends CharacterListState {
  final String message;
  final bool isRetryable;

  CharacterListError({
    required this.message,
    this.isRetryable = true,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CharacterListError &&
        other.message == message &&
        other.isRetryable == isRetryable;
  }

  @override
  int get hashCode {
    return Object.hash(message, isRetryable);
  }
}