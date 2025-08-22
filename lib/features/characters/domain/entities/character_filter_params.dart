/// Parâmetros de filtro para busca de personagens na Rick and Morty API
/// 
/// Baseado na documentação oficial: https://rickandmortyapi.com/documentation/#filter-characters
/// 
/// Todos os filtros são opcionais e podem ser combinados.
/// Múltiplos valores para o mesmo filtro são tratados como OR.
class CharacterFilterParams {
  /// Nome do personagem (busca parcial, case-insensitive)
  /// Exemplo: "rick" encontra "Rick Sanchez", "Rick Potion #9", etc.
  final String? name;

  /// Status do personagem
  /// Valores válidos: 'alive', 'dead', 'unknown'
  final List<String>? status;

  /// Espécie do personagem
  /// Exemplos: 'Human', 'Alien', 'Humanoid', 'unknown', etc.
  final List<String>? species;

  /// Tipo/subtipo do personagem
  /// Exemplos: 'Genetic experiment', 'Parasite', 'Clone', etc.
  final List<String>? type;

  /// Gênero do personagem
  /// Valores válidos: 'Male', 'Female', 'Genderless', 'unknown'
  final List<String>? gender;

  /// Número da página para paginação (começa em 1)
  final int page;

  const CharacterFilterParams({
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
    this.page = 1,
  });

  /// Construtor vazio (sem filtros aplicados)
  const CharacterFilterParams.empty() : this();

  /// Construtor apenas para paginação
  const CharacterFilterParams.pageOnly(this.page)
      : name = null,
        status = null,
        species = null,
        type = null,
        gender = null;

  /// Cria uma cópia com os parâmetros alterados
  CharacterFilterParams copyWith({
    String? name,
    List<String>? status,
    List<String>? species,
    List<String>? type,
    List<String>? gender,
    int? page,
  }) {
    return CharacterFilterParams(
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      page: page ?? this.page,
    );
  }

  /// Cria uma cópia com apenas o número da página alterado
  CharacterFilterParams copyWithPage(int newPage) {
    return copyWith(page: newPage);
  }

  /// Verifica se há algum filtro ativo (exceto página)
  bool get hasFilters {
    return name != null ||
           (status?.isNotEmpty == true) ||
           (species?.isNotEmpty == true) ||
           (type?.isNotEmpty == true) ||
           (gender?.isNotEmpty == true);
  }

  /// Verifica se os filtros são iguais (ignora página)
  bool hasSameFilters(CharacterFilterParams other) {
    return name == other.name &&
           _listEquals(status, other.status) &&
           _listEquals(species, other.species) &&
           _listEquals(type, other.type) &&
           _listEquals(gender, other.gender);
  }

  /// Gera uma chave única para cache baseada nos filtros
  String get cacheKey {
    final parts = <String>[];
    
    if (name != null && name!.isNotEmpty) {
      parts.add('name:${name!.toLowerCase()}');
    }
    
    if (status?.isNotEmpty == true) {
      parts.add('status:${status!.map((s) => s.toLowerCase()).join(",")}');
    }
    
    if (species?.isNotEmpty == true) {
      parts.add('species:${species!.map((s) => s.toLowerCase()).join(",")}');
    }
    
    if (type?.isNotEmpty == true) {
      parts.add('type:${type!.map((s) => s.toLowerCase()).join(",")}');
    }
    
    if (gender?.isNotEmpty == true) {
      parts.add('gender:${gender!.map((s) => s.toLowerCase()).join(",")}');
    }
    
    return parts.isEmpty ? 'no-filters' : parts.join('|');
  }

  /// Gera uma descrição amigável dos filtros aplicados
  String get filtersDescription {
    if (!hasFilters) return 'Todos os personagens';
    
    final descriptions = <String>[];
    
    if (name != null && name!.isNotEmpty) {
      descriptions.add('Nome: "$name"');
    }
    
    if (status?.isNotEmpty == true) {
      descriptions.add('Status: ${status!.join(", ")}');
    }
    
    if (species?.isNotEmpty == true) {
      descriptions.add('Espécies: ${species!.join(", ")}');
    }
    
    if (type?.isNotEmpty == true) {
      descriptions.add('Tipos: ${type!.join(", ")}');
    }
    
    if (gender?.isNotEmpty == true) {
      descriptions.add('Gêneros: ${gender!.join(", ")}');
    }
    
    return descriptions.join(' • ');
  }

  /// Converte os parâmetros para query string da API
  Map<String, String> toQueryParameters() {
    final params = <String, String>{};
    
    if (name != null && name!.isNotEmpty) {
      params['name'] = name!;
    }
    
    // API da Rick and Morty não suporta múltiplos valores para o mesmo parâmetro
    // Então usamos apenas o primeiro valor de cada lista
    if (status?.isNotEmpty == true) {
      params['status'] = status!.first.toLowerCase();
    }
    
    if (species?.isNotEmpty == true) {
      params['species'] = species!.first;
    }
    
    if (type?.isNotEmpty == true) {
      params['type'] = type!.first;
    }
    
    if (gender?.isNotEmpty == true) {
      params['gender'] = gender!.first.toLowerCase();
    }
    
    params['page'] = page.toString();
    
    return params;
  }

  /// Método auxiliar para comparar listas (pode ser nulo)
  bool _listEquals<T>(List<T>? list1, List<T>? list2) {
    if (list1 == null && list2 == null) return true;
    if (list1 == null || list2 == null) return false;
    if (list1.length != list2.length) return false;
    
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    
    return true;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is CharacterFilterParams &&
           other.name == name &&
           _listEquals(other.status, status) &&
           _listEquals(other.species, species) &&
           _listEquals(other.type, type) &&
           _listEquals(other.gender, gender) &&
           other.page == page;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      status?.join(','),
      species?.join(','),
      type?.join(','), 
      gender?.join(','),
      page,
    );
  }

  @override
  String toString() {
    return 'CharacterFilterParams('
           'name: $name, '
           'status: $status, '
           'species: $species, '
           'type: $type, '
           'gender: $gender, '
           'page: $page)';
  }
}