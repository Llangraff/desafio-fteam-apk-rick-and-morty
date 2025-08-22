import 'package:json_annotation/json_annotation.dart';

part 'character_model.g.dart';

@JsonSerializable()
class CharacterModel {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final OriginModel origin;
  final LocationModel location;
  final List<String> episode;
  final String url;
  final String created;
  final String image;

  const CharacterModel({
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

  factory CharacterModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterModelFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CharacterModel &&
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
    return 'CharacterModel(id: $id, name: $name, status: $status, species: $species, type: $type, gender: $gender, origin: ${origin.name}, location: ${location.name}, episodes: ${episode.length})';
  }
}

/// Modelo para representar a origem de um personagem
@JsonSerializable()
class OriginModel {
  final String name;
  final String url;

  const OriginModel({
    required this.name,
    required this.url,
  });

  factory OriginModel.fromJson(Map<String, dynamic> json) =>
      _$OriginModelFromJson(json);

  Map<String, dynamic> toJson() => _$OriginModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OriginModel &&
        other.name == name &&
        other.url == url;
  }

  @override
  int get hashCode => Object.hash(name, url);

  @override
  String toString() => 'OriginModel(name: $name, url: $url)';
}

/// Modelo para representar a localização de um personagem
@JsonSerializable()
class LocationModel {
  final String name;
  final String url;

  const LocationModel({
    required this.name,
    required this.url,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationModel &&
        other.name == name &&
        other.url == url;
  }

  @override
  int get hashCode => Object.hash(name, url);

  @override
  String toString() => 'LocationModel(name: $name, url: $url)';
}