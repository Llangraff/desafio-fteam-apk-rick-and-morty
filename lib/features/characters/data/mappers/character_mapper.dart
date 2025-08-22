import '../../domain/entities/character.dart';
import '../../domain/entities/page_info.dart';
import '../../domain/entities/characters_page.dart';
import '../models/character_model.dart';
import '../models/page_info_model.dart';
import '../models/characters_response_model.dart';

/// Extensões para mapeamento entre modelos de dados e entidades de domínio
extension CharacterModelMapper on CharacterModel {
  /// Converte CharacterModel para Character (entidade de domínio)
  Character toDomain() {
    return Character(
      id: id,
      name: name,
      status: status,
      species: species,
      type: type,
      gender: gender,
      origin: origin.toDomain(),
      location: location.toDomain(),
      episode: episode,
      url: url,
      created: created,
      image: image,
    );
  }
}

extension PageInfoModelMapper on PageInfoModel {
  /// Converte PageInfoModel para PageInfo (entidade de domínio)
  PageInfo toDomain() {
    return PageInfo(
      count: count,
      pages: pages,
      next: next,
      prev: prev,
    );
  }
}

extension CharactersResponseModelMapper on CharactersResponseModel {
  /// Converte CharactersResponseModel para CharactersPage (entidade de domínio)
  CharactersPage toDomain() {
    return CharactersPage(
      info: info.toDomain(),
      characters: results.map((model) => model.toDomain()).toList(),
    );
  }
}

extension OriginModelMapper on OriginModel {
  /// Converte OriginModel para CharacterOrigin (entidade de domínio)
  CharacterOrigin toDomain() {
    return CharacterOrigin(
      name: name,
      url: url,
    );
  }
}

extension LocationModelMapper on LocationModel {
  /// Converte LocationModel para CharacterLocation (entidade de domínio)
  CharacterLocation toDomain() {
    return CharacterLocation(
      name: name,
      url: url,
    );
  }
}

/// Extensões para mapeamento reverso (se necessário para cache/offline)
extension CharacterMapper on Character {
  /// Converte Character para CharacterModel (modelo de dados)
  CharacterModel toModel() {
    return CharacterModel(
      id: id,
      name: name,
      status: status,
      species: species,
      type: type,
      gender: gender,
      origin: origin.toModel(),
      location: location.toModel(),
      episode: episode,
      url: url,
      created: created,
      image: image,
    );
  }
}

extension CharacterOriginMapper on CharacterOrigin {
  /// Converte CharacterOrigin para OriginModel (modelo de dados)
  OriginModel toModel() {
    return OriginModel(
      name: name,
      url: url,
    );
  }
}

extension CharacterLocationMapper on CharacterLocation {
  /// Converte CharacterLocation para LocationModel (modelo de dados)
  LocationModel toModel() {
    return LocationModel(
      name: name,
      url: url,
    );
  }
}