/// Entidade que representa informações de paginação
/// 
/// Esta é a representação de domínio pura para controle de páginas
class PageInfo {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  const PageInfo({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  /// Verifica se existe uma próxima página
  bool get hasNext => next != null && next!.isNotEmpty;

  /// Verifica se existe uma página anterior
  bool get hasPrevious => prev != null && prev!.isNotEmpty;

  /// Verifica se é a primeira página
  bool get isFirstPage => !hasPrevious;

  /// Verifica se é a última página
  bool get isLastPage => !hasNext;

  /// Obtém o número da próxima página
  int? get nextPageNumber {
    if (!hasNext) return null;
    
    try {
      final uri = Uri.parse(next!);
      final pageParam = uri.queryParameters['page'];
      return pageParam != null ? int.parse(pageParam) : null;
    } catch (e) {
      return null;
    }
  }

  /// Obtém o número da página anterior
  int? get previousPageNumber {
    if (!hasPrevious) return null;
    
    try {
      final uri = Uri.parse(prev!);
      final pageParam = uri.queryParameters['page'];
      return pageParam != null ? int.parse(pageParam) : null;
    } catch (e) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PageInfo &&
        other.count == count &&
        other.pages == pages &&
        other.next == next &&
        other.prev == prev;
  }

  @override
  int get hashCode {
    return Object.hash(count, pages, next, prev);
  }

  @override
  String toString() {
    return 'PageInfo(count: $count, pages: $pages, hasNext: $hasNext, hasPrevious: $hasPrevious)';
  }
}