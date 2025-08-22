/// Entidade que representa um personagem do Rick and Morty
///
/// Esta é a representação de domínio pura, sem dependências externas
class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final CharacterOrigin origin;
  final CharacterLocation location;
  final List<String> episode;
  final String url;
  final String created;
  final String image;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.episode,
    required this.url,
    required this.created,
    required this.image,
  });

  /// Verifica se o personagem está vivo
  bool get isAlive => status.toLowerCase() == 'alive';

  /// Verifica se o personagem está morto  
  bool get isDead => status.toLowerCase() == 'dead';

  /// Verifica se o status é desconhecido
  bool get isUnknown => status.toLowerCase() == 'unknown';

  /// Obtém a cor semântica baseada no status
  CharacterStatusColor get statusColor {
    switch (status.toLowerCase()) {
      case 'alive':
        return CharacterStatusColor.green;
      case 'dead':
        return CharacterStatusColor.red;
      default:
        return CharacterStatusColor.grey;
    }
  }

  /// Número total de episódios que aparece
  int get totalEpisodes => episode.length;

  /// Obtém o ID do episódio de uma URL
  static int? getEpisodeIdFromUrl(String episodeUrl) {
    final match = RegExp(r'/episode/(\d+)').firstMatch(episodeUrl);
    return match != null ? int.tryParse(match.group(1)!) : null;
  }

  /// Lista de IDs dos episódios
  List<int> get episodeIds {
    return episode
        .map((url) => getEpisodeIdFromUrl(url))
        .where((id) => id != null)
        .cast<int>()
        .toList();
  }

  /// Verifica se o personagem é do gênero masculino
  bool get isMale => gender.toLowerCase() == 'male';

  /// Verifica se o personagem é do gênero feminino
  bool get isFemale => gender.toLowerCase() == 'female';

  /// Verifica se o gênero é desconhecido
  bool get isGenderUnknown => gender.toLowerCase() == 'unknown';

  /// Verifica se não tem gênero
  bool get isGenderless => gender.toLowerCase() == 'genderless';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Character &&
        other.id == id &&
        other.name == name &&
        other.status == status &&
        other.species == species &&
        other.type == type &&
        other.gender == gender &&
        other.origin == origin &&
        other.location == location &&
        other.url == url &&
        other.created == created &&
        other.image == image;
  }

  @override
  int get hashCode {
    return Object.hash(
      id, name, status, species, type, gender,
      origin, location, url, created, image
    );
  }

  @override
  String toString() {
    return 'Character(id: $id, name: $name, status: $status, species: $species, type: $type, gender: $gender, origin: ${origin.name}, location: ${location.name}, episodes: ${episode.length})';
  }
}

/// Enum para representar as cores semânticas dos status
enum CharacterStatusColor {
  green,
  red,
  grey,
}

/// Representa a origem de um personagem (planeta/dimensão)
class CharacterOrigin {
  final String name;
  final String url;

  const CharacterOrigin({
    required this.name,
    required this.url,
  });

  /// Verifica se a origem é desconhecida
  bool get isUnknown => name.toLowerCase() == 'unknown';

  /// Obtém o ID da origem de uma URL
  static int? getOriginIdFromUrl(String originUrl) {
    if (originUrl.isEmpty) return null;
    final match = RegExp(r'/location/(\d+)').firstMatch(originUrl);
    return match != null ? int.tryParse(match.group(1)!) : null;
  }

  /// ID da origem (se disponível)
  int? get originId => getOriginIdFromUrl(url);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CharacterOrigin &&
        other.name == name &&
        other.url == url;
  }

  @override
  int get hashCode => Object.hash(name, url);

  @override
  String toString() => 'CharacterOrigin(name: $name, url: $url)';
}

/// Representa a localização atual de um personagem
class CharacterLocation {
  final String name;
  final String url;

  const CharacterLocation({
    required this.name,
    required this.url,
  });

  /// Verifica se a localização é desconhecida
  bool get isUnknown => name.toLowerCase() == 'unknown';

  /// Obtém o ID da localização de uma URL
  static int? getLocationIdFromUrl(String locationUrl) {
    if (locationUrl.isEmpty) return null;
    final match = RegExp(r'/location/(\d+)').firstMatch(locationUrl);
    return match != null ? int.tryParse(match.group(1)!) : null;
  }

  /// ID da localização (se disponível)
  int? get locationId => getLocationIdFromUrl(url);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CharacterLocation &&
        other.name == name &&
        other.url == url;
  }

  @override
  int get hashCode => Object.hash(name, url);

  @override
  String toString() => 'CharacterLocation(name: $name, url: $url)';
}